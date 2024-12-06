{-# LANGUAGE FlexibleContexts #-}

import qualified Data.Map as M
import Data.List (stripPrefix)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import Control.Monad (void)

import XMonad hiding ( (|||) )
import XMonad.Actions.FloatKeys (keysMoveWindow, keysResizeWindow)
import XMonad.Actions.WindowGo (raise, runOrRaise) -- raiseMaybe
import qualified XMonad.Actions.GridSelect as GS
import qualified XMonad.Actions.CycleWS as CWS
import XMonad.Actions.PerWindowKeys (bindFirst)
import XMonad.Hooks.ManageHelpers ((-?>))
import qualified XMonad.Hooks.ManageDocks as MD
import qualified XMonad.Hooks.ManageHelpers as MH
import qualified XMonad.Hooks.ServerMode as SM
import qualified XMonad.Hooks.StatusBar as SB
import qualified XMonad.Hooks.StatusBar.PP as SBP
import qualified XMonad.Hooks.EwmhDesktops as Ewm
import qualified XMonad.Hooks.UrgencyHook as U
import qualified XMonad.Layout.NoBorders as NB
-- import XMonad.Layout.IM (withIM, Property(ClassName))
import XMonad.Layout.LayoutCombinators ((|||))
import qualified XMonad.Layout.LayoutCombinators as LJ
import qualified XMonad.Layout.Renamed as LR
import qualified XMonad.Layout.Spacing as SP
-- import qualified XMonad.Layout.Reflect as Refl
import qualified XMonad.Layout.PerWorkspace as PW
import qualified XMonad.Prompt as P
import qualified XMonad.Prompt.Shell as PS
import qualified XMonad.Prompt.XMonad as XmP
import qualified XMonad.Prompt.Window as PW
import qualified XMonad.StackSet as W
import qualified XMonad.Util.EZConfig as EZ
import qualified XMonad.Util.Hacks as UH
import qualified XMonad.Util.NamedScratchpad as NS
-- import XMonad.Util.Paste (sendKey)
import qualified XMonad.Util.WindowProperties as WP

currentWindowProp prop = do
  d <- asks display
  gets (W.peek . windowset) >>=
    maybe (return Nothing) (\w -> getStringProperty d w prop)

currentWindowName = currentWindowProp "WM_NAME"

jaoscript scrpt = "/home/jao/etc/config/bin/" ++ scrpt

defFace = "Hack-10"

promptKeys = M.fromList [((controlMask, xK_a), P.startOfLine)
                        ,((controlMask, xK_b), P.moveCursor P.Prev)
                        ,((mod1Mask, xK_b), P.moveWord P.Prev)
                        ,((controlMask, xK_d), P.deleteString P.Next)
                        ,((mod1Mask, xK_d), P.killWord P.Next)
                        ,((controlMask, xK_e), P.endOfLine)
                        ,((controlMask, xK_f), P.moveCursor P.Next)
                        ,((mod1Mask, xK_f), P.moveWord P.Next)
                        ,((controlMask, xK_g), P.quit)
                        ,((controlMask, xK_k), P.killAfter)
                        ,((controlMask, xK_n), P.moveHistory W.focusUp')
                        ,((mod1Mask, xK_n), P.moveHistory W.focusUp')
                        ,((controlMask, xK_p), P.moveHistory W.focusDown')
                        ,((mod1Mask, xK_p), P.moveHistory W.focusDown')
                        ,((controlMask, xK_y), P.pasteString)
                        ,((mod1Mask, xK_d), P.killWord P.Next)
                        ]

promptKM = M.union promptKeys P.defaultXPKeymap

popConfig = P.def { P.font = "xft:" ++ defFace
                  , P.promptKeymap = promptKM
                  , P.position = P.Bottom
                  , P.height = 25
                  , P.promptBorderWidth = 1
                  }

darkPopConfig = popConfig { P.fgColor = "grey60"
                          , P.bgColor = "grey10"
                          , P.fgHLight = "lightgoldenrod2"
                          , P.bgHLight = "grey20"
                          , P.borderColor = "grey30"
                          }

lightPopConfig = popConfig { P.fgColor = "grey10"
                           , P.bgColor = "#efebe7"
                           , P.fgHLight = "sienna"
                           , P.bgHLight = "lightyellow"
                           , P.borderColor = "grey70"
                           }

defWorkspaces = ["e", "f", "d"]

isEmacs = className =? "Emacs" <||> title =? "emacsclient"
isntEmacs = not `fmap` isEmacs

raiseEmacs = raise isEmacs
runOrRaiseEmacs = do
  emacs <- liftIO $ lookupEnv "emacs"
  runOrRaise (case emacs of Just e -> e; _ -> "eterm") isEmacs

runOrRaiseFirefox = runOrRaise "firefox" $ className =? "Firefox"

toggleEmacs other = do
  ems <- mapM (WP.focusedHasProperty . WP.ClassName) ["Emacs"]
  ems' <- WP.focusedHasProperty (WP.Title "emacsclient")
  if or (ems':ems) then other else runOrRaiseEmacs

emacsclient x = spawn $ "emacsclient -e '(" ++ x ++ ")'"

zathuraToEmacs = do
  z <- WP.focusedHasProperty (WP.ClassName "Zathura")
  tl <- if z then currentWindowName else return Nothing
  case tl of
    Just fn -> emacsclient ("jao-x11-zathura-goto-org \"" ++ fn ++ "\"")
    Nothing -> return ()

keyDefs conf =
  [ ("<XF86MonBrightnessUp>", backlight "5%+")
  , ("<XF86MonBrightnessDown>", backlight "5%-")
  , ("<XF86BrightnessUp>", backlight "5%+")
  , ("<XF86BrightnessDown>", backlight "5%-")
  , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 10%+")
  , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 10%-")
  , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
  , ("<XF86AudioPlay>", emacsclient "message \"audio play\"")
  , ("<Print>",  spawn "import -window root ~/screenshot.png")
  , ("M-<Right>", move (10,0))
  , ("M-<Left>", move (-10,0))
  , ("M-<Up>", move (0,-10))
  , ("M-<Down>", move (0,10))
  , ("M-0", toWS "NSP")
  , ("M-1", toWS "e")
  , ("M-2", toWS "f")
  , ("M-3", toWS "d")
  , ("M-5", CWS.nextWS)
  , ("C-M-5", CWS.shiftToNext)
  , ("M-C-<Right>", resize (10,0) (0,0))
  , ("M-C-<Left>", resize (-10,0) (0,1))
  , ("M-C-<Up>", resize (0,-10) (0,0))
  , ("M-C-<Down>", resize (0,10) (0,0))
  , ("M-a", scratch "spt")
  , ("M-b", sendMessage MD.ToggleStruts)
  , ("M-d", toggleEmacs $ toWS "d")
  , ("M-e", toggleEmacs runOrRaiseFirefox)
  , ("M-C-e", spawn "emacsclient -c")
  , ("M-S-e", spawn (jaoscript "eterm"))
  , ("M-p", zathuraToEmacs >> raiseEmacs)
  , ("M-m", raiseEmacs >> emacsclient "jao-transient-media")
  , ("M-r", bindFirst [(isntEmacs, runCmd),
                       (pure True, emacsclient "jao-transient-recoll")])
  , ("M-S-r", runCmd)
  , ("M-s", raiseEmacs >> emacsclient "jao-transient-streaming")
  , ("M-S-s", withFocused $ windows . W.sink)
  , ("M-t", spawn "kitty")
  , ("M-w", raiseEmacs >> emacsclient "jao-transient-utils")
  , ("M-x 1", emacsAfio "main")
  , ("M-x 2", emacsAfio "mail")
  , ("M-x 3", emacsAfio "www")
  , ("M-x 4", emacsAfio "docs")
  , ("M-x 1", emacsAfio "main")
  , ("M-x k", kill)
  , ("M-x M-f", withFocused float)
  , ("M-x s", withFocused $ windows . W.sink)
  , ("M-x g", GS.goToSelected GS.def)
  , ("M-x S-g", GS.bringSelected GS.def)
  , ("M-x f", jumpToL "F")
  , ("M-x l", jumpToLE "L")
  , ("M-x n", CWS.nextWS)
  , ("M-x S-n", CWS.shiftToNext)
  , ("M-x r", jumpToLE "R")
  , ("M-x t", jumpToLE "T")
  , ("M-x w", PW.windowPrompt
                 conf { P.autoComplete = Just 500000 }
                 PW.Bring PW.allWindows)
  -- , ("M-x n", sendMessage NextLayout)
  , ("M-S-x", XmP.xmonadPrompt $ conf {P.position = P.Top})
  , ("M-z l", xdgscr "activate")
  , ("M-z u", spawn "toggle-screensaver.sh")
  , ("M-z z", zzCmd "suspend")
  , ("M-z h", zzCmd "hibernate")
  , ("M-z b", zzCmd "hybrid")
  , ("M-z l", i3lock)
  ] where jumpToL x = void (sendMessage (LJ.JumpToLayout x))
          withEmacs x = jumpToL "F" >> raiseEmacs >> emacsclient x
          emacsAfio f = withEmacs $ "jao-afio-goto-" ++ f
          -- sendCtrlC = sendKey controlMask xK_c
          toWS = windows . W.greedyView
          jumpToLE x = emacsAfio "scratch-1" >> jumpToL x
          backlight x = spawn $ "brightnessctl -q s " ++ x
          i3lock = spawn "i3lock -e -i ~/.lockimage"
          xdgscr = spawn . ("xdg-screensaver " ++)
          zzCmd = spawn . ("sudo systemctl " ++)
          move r = withFocused $ keysMoveWindow r
          runCmd = PS.shellPrompt $ conf {P.position = P.Top}
          resize a b = withFocused $ keysResizeWindow a b
          scratch = NS.namedScratchpadAction scratchpads

layouts = PW.onWorkspace "d" lytTall lytFullTall
  where
    spacing n =
      SP.spacingRaw False (SP.Border n 0 n 0) True (SP.Border 0 n 0 n) True
    namedLyt n = LR.renamed [LR.Replace n]
    lytFull = namedLyt "F" Full
    lytTall = namedLyt "T" $ spacing 1 (Tall 1 (1/100) (1/2))
    -- lytLeft = namedLyt "L" $ withIM (11/26) (ClassName "Zathura") Full
    -- lytRight = namedLyt "R" $ Refl.reflectHoriz lytLeft
    -- emacsLyts = lytLeft ||| lytRight ||| lytFullTall
    lytFullTall = lytFull ||| lytTall

scratchpads =
  [ NS.NS "spotify" "spotify" (className =? "spotify") cf
  , NS.NS "spt" "kitty --title spt -e spt" (title =? "spt") cf
  ] where cf = centerFloat (3/4) (7/8)

centerFloat width height
  = NS.customFloating $ W.RationalRect marginLeft marginTop width height
    where marginLeft = (1 - width) / 2
          marginTop = (1 - height) / 2

mHook = composeAll cls <+> MH.composeOne [dlg] <+> scr
    where
      dlg = MH.isDialog -?> MH.doCenterFloat
      cfs = ["Display", "feh", "MPlayer", "Vlc", "mpv", "Mpv", "xli",
             "Blueman-services", "Blueman-manager",
             "Pavucontrol", "Pavumeter", "Xmessage"]
      cls = [className =? x --> MH.doCenterFloat | x <- cfs]
      scr = NS.namedScratchpadManageHook scratchpads

simplePP = SBP.def { SBP.ppLayout = const ""
                   , SBP.ppHidden = const ""
                   , SBP.ppCurrent = SBP.xmobarColor "gray40" ""
                   , SBP.ppTitle = ellipsis 35 . stripOrg
                   , SBP.ppSep = ":"
                   , SBP.ppUrgent = const (SBP.xmobarColor "orangered3" "" "*")
                   }
  where ellipsis n s | length s > n = take (n - 3) s ++ " ..."
                     | otherwise = s
        stripOrg s = fromMaybe s (stripPrefix "~/org/doc/" s)

main = do
  scheme <- lookupEnv "JAO_COLOR_SCHEME"
  let dark = Just "dark" == scheme
      popCfg = if dark then darkPopConfig else lightPopConfig
      defBorder = if dark then "grey30" else "grey95"
      defFBorder = if dark then "grey35" else "grey95"
      ehook = SM.serverModeEventHook <+> UH.trayerPaddingXmobarEventHook
      lyt = NB.smartBorders layouts
      localStartupHook = spawn "xmobars.sh" >> runOrRaiseEmacs
      sb = SB.withSB $ SB.statusBarProp "xmobar" (pure simplePP)
      uhook = U.withUrgencyHook U.NoUrgencyHook
  xmonad . uhook . sb . MD.docks . Ewm.ewmh $ def {
    manageHook = mHook
    , handleEventHook = ehook
    , layoutHook = MD.avoidStruts lyt
    , startupHook = localStartupHook
    , modMask = mod4Mask
    , borderWidth = 1
    , focusedBorderColor = defFBorder
    , normalBorderColor = defBorder
    , terminal = "kitty"
    , workspaces = defWorkspaces
    , focusFollowsMouse = False
    } `EZ.removeKeysP` ["M-j", "M-n", "M-w", "M-m", "M-r", "M-p", "M-l", "M-<Space>"]
      `EZ.additionalKeysP` keyDefs popCfg

