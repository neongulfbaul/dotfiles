import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders

import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.EwmhDesktops

main :: IO ()
main = xmonad $ withSB myStatusBar myConfigWithKeys

myConfig = def
    { terminal           = "kitty"
    , modMask            = mod4Mask    -- Use Super/Windows key as mod
    , borderWidth        = 1
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#ff0000"
    , layoutHook         = myLayout
    , manageHook         = myManageHook <+> manageDocks
    , logHook            = dynamicLogWithPP myXmobarPP
    , startupHook        = myStartupHook 
    }

-- Layouts with gaps and spacing for a clean DWM-like look
myLayout = avoidStruts $ smartBorders $ layoutHook def

-- $ gaps [(U, 5), (R, 5), (L, 5), (D, 5)] $ spacing 5 $ layoutHook def

-- ManageHook for floating certain window
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "Firefox" --> doShift "2"
    , className =? "feh"     --> hasBorder False
    , className =? "Firefox" --> hasBorder False
    ]

-- Startup applications or setup
myStartupHook = do
    spawn "feh --bg-scale ~/path/to/your/wallpaper.jpg" -- Set wallpaper
    spawn "picom" -- Compositor

-- Keybindings
myKeys :: [(String, X ())]
myKeys =
    [ ("M-S-<Return>", spawn "kitty")     -- Launch terminal
    , ("M-p", spawn "rofi -show drun")    -- Launch rofi
    , ("M-S-c", kill)                    -- Close window
    , ("M-S-r", restart "xmonad" True)   -- Restart xmonad
    , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +10%")
    , ("<XF86MonBrightnessDown>", spawn "brightnessctl s 10-%")
    --, ("<XF86BrightnessUp>", backlight "5%+")
    --, ("<XF86BrightnessDown>", backlight "5%-")
    --, ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 10%+")
    --, ("<XF86AudioLowerVolume>", spawn "amixer sset Master 10%-")
    ]

myConfigWithKeys = myConfig `additionalKeysP` myKeys

-- StatusBar configuration mimicking DWM's style
myStatusBar :: StatusBarConfig
myStatusBar = statusBarProp "xmobar ~/.dotfiles/config/xmobarrc" (pure myXmobarPP)

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = \ws -> clickableWrap ((read ws :: Int) - 1) $ xmobarColor foregroundColorCurrent backgroundColorCurrent $ wrap "  " "  " ws
    , ppHidden          = \s -> clickableWrap ((read s :: Int) - 1) $ xmobarColor foregroundColorHidden "" $ wrap "  " "  " s
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

    createDwmBox :: String -> String -> String
    createDwmBox color prefix = "<box type=HBoth offset=L20 color="++color++"><box type=Top mt=3 color="++color++"><box type=Top color="++color++">" ++ prefix ++ "</box></box></box>"

