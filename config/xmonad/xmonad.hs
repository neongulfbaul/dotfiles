import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders

import System.Directory (doesFileExist)
import Control.Monad (when)

import Data.Monoid

import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.EwmhDesktops

import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set
-- import qualified XMonad.StackSet as W

main :: IO ()
main = xmonad $ docks $ withSB myStatusBar myConfigWithKeys

myConfig = def
    { terminal           = "kitty"
    , modMask            = mod4Mask    -- Use Super/Windows key as mod
    , borderWidth        = 1
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#ff0000"
    , layoutHook         = myLayout
    , manageHook         = myManageHook <+> manageDocks
    --, logHook            = dynamicLogWithPP myXmobarPP
    , logHook = do
        dynamicLogWithPP myXmobarPP
        ws <- gets (W.currentTag . windowset)
        liftIO $ do
          let notifFile = "/home/neon/.cache/xmobar/notifications"
          exists <- doesFileExist notifFile
          when exists $ do
            contents <- readFile notifFile
            let remaining = unlines . filter (/= ws) . lines $ contents
            writeFile notifFile remaining
    , startupHook        = myStartupHook 
    }

-- Layouts with gaps and spacing for a clean DWM-like look
-- myLayout = avoidStruts $ smartBorders $ layoutHook def

myLayout = avoidStruts $ toggleLayouts Full $ smartBorders $ gaps [(U,10), (D,10), (L,10), (R,10)] $
           spacing 8 $
           Tall 1 (3/100) (1/2) ||| Full

-- Notification on xmobar
getNotifiedWorkspaces :: Set.Set String
getNotifiedWorkspaces = unsafePerformIO $ do
  exists <- doesFileExist "/home/neon/.cache/xmobar/notifications"
  if exists
    then do
      contents <- readFile "/home/neon/.cache/xmobar/notifications"
      return . Set.fromList . lines $ contents
    else return Set.empty

-- Font setting
myFont :: String
myFont = "xft:Ubuntu:regular:size=9:antialias=true:hinting=true"

-- $ gaps [(U, 5), (R, 5), (L, 5), (D, 5)] $ spacing 5 $ layoutHook def

-- ManageHook for floating certain window
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "virtual machine manager" --> doFloat
    , className =? "confirm" --> doFloat
    , className =? "dialog" --> doFloat
    , className =? "download" --> doFloat
    , className =? "error" --> doFloat
    , className =? "Firefox" --> hasBorder False
    , className =? "Firefox" --> doShift "2"
    , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat
    , className =? "feh"     --> hasBorder False
    ]

-- Startup applications or setup
myStartupHook = do
    spawn "picom --config ~/.dotfiles/config/picom/picom.conf"
    spawn "dunst"
    spawn "feh --bg-scale ~/git/wallpapers-nord/gun-girl.png" -- Set wallpaper

-- Keybindings
myKeys :: [(String, X ())]
myKeys =
    [ ("M-S-<Return>", spawn "kitty")     -- Launch terminal
    , ("M-p", spawn "rofi -show drun")    -- Launch rofi
    , ("M-S-c", kill)                    -- Close window
    , ("M-S-r", restart "xmonad" True)   -- Restart xmonad
    , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +10%")
    , ("<XF86MonBrightnessDown>", spawn "brightnessctl s 10-%")
    , ("M-s", spawn "flameshot gui")
    , ("M-g", sendMessage ToggleGaps)        -- toggle gaps
    , ("M-f", sendMessage ToggleLayout)      -- toggle fullscreen
    , ("M-b", sendMessage ToggleStruts) -- toggles avoiding xmobar
    , ("M-C-b", spawn "~/.dotfiles/config/scripts/toggle-xmobar.sh"
           >> sendMessage ToggleStruts
           >> sendMessage ToggleGaps)
    --, ("<XF86BrightnessUp>", backlight "5%+")
    --, ("<XF86BrightnessDown>", backlight "5%-")
    --, ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 10%+")
    --, ("<XF86AudioLowerVolume>", spawn "amixer sset Master 10%-")
    ]

myConfigWithKeys = myConfig `additionalKeysP` myKeys

-- StatusBar configuration 
myStatusBar :: StatusBarConfig
myStatusBar = statusBarProp "xmobar -x 0 -d ~/.dotfiles/config/xmobar/xmobarrc" (pure myXmobarPP)

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = \ws -> clickableWrap ((read ws :: Int) - 1) $ xmobarColor foregroundColorCurrent backgroundColorCurrent $ wrap "  " "  " ws
    , ppHidden = \ws ->
        let color = if Set.member ws getNotifiedWorkspaces then "#e78284" else "#ffffff"
        in clickableWrap ((read ws :: Int) - 1) $ xmobarColor color "" $ wrap "  " "  " ws
    --, ppHidden          = \s -> clickableWrap ((read s :: Int) - 1) $ xmobarColor foregroundColorHidden "" $ wrap "  " "  " s
    , ppHiddenNoWindows = \s -> clickableWrap ((read s :: Int) - 1) $ xmobarColor hiddenNoWindowsColor "" $ wrap "  " "  " s
    , ppUrgent          = \s -> clickableWrap ((read s :: Int) - 1) $ xmobarBorder "Top" urgentColor 4 ("  " ++ s ++ "  ")
    , ppTitle           = xmobarColor "#ffffff" "" . shorten 60
    , ppSep             = " | "
    , ppWsSep           = " "
    , ppLayout          = const ""
    }
  where
    foregroundColorCurrent   = "#ffffff"
    backgroundColorCurrent   = "#808080" -- Grey background for current workspace
    foregroundColorHidden    = "#ffffff" -- White text for hidden workspaces
    hiddenNoWindowsColor     = "#cccccc" -- Grey text for hidden no windows workspaces
    urgentColor              = "#ff0000"

    -- Helper functions for DWM-like clickable workspaces
    clickableWrap :: Int -> String -> String
    clickableWrap index str = "<action=xdotool key super+" ++ show (index + 1) ++ ">" ++ str ++ "</action>"
