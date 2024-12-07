import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

main :: IO ()
main = xmonad $ withSB myStatusBar myConfig

myConfig = def
    { terminal           = "kitty"
    , modMask            = mod4Mask    -- Use Super/Windows key as mod
    , borderWidth        = 2
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#ff0000"
    , layoutHook         = myLayout
    , manageHook         = myManageHook <+> manageDocks
    , logHook            = return ()  -- xmobar handles logHook
    , startupHook        = myStartupHook
    }

-- Layouts with gaps and spacing for a clean DWM-like look
myLayout = avoidStruts $ gaps [(U, 30), (R, 10), (L, 10), (D, 10)] $ spacing 10 $ layoutHook def

-- ManageHook for floating certain windows
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "Firefox" --> doShift "2"
    ]

-- Optional startup applications or setup
myStartupHook = do
    spawn "xmobar"
    spawn "feh --bg-scale ~/path/to/your/wallpaper.jpg" -- Set wallpaper
    spawn "picom" -- Compositor example

-- Keybindings
myKeys =
    [ ("M-S-<Return>", spawn "kitty")     -- Launch terminal
    , ("M-p", spawn "rofi -show run")    -- Launch rofi
    , ("M-S-c", kill)                    -- Close window
    , ("M-S-r", restart "xmonad" True)   -- Restart xmonad
    ]

myConfigWithKeys = myConfig `additionalKeysP` myKeys

-- StatusBar configuration mimicking DWM's style
myStatusBar :: StatusBarConfig
-- myStatusBar = statusBarProp "xmobar" (pure myXmobarPP)

myStatusBar = statusBarProp "xmobar ~/.dotfiles/config/xmobar.hs" (pure myXmobarPP)

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = \ws -> xmobarBorder "Top" foregroundColor 4 $ xmobarColor foregroundColor backgroundColor $ wrap "  " "  " ws
    , ppHidden          = \s -> clickableWrap ((read s :: Int) - 1) (createDwmBox foregroundColor ("  " ++ s ++ "  "))
    , ppHiddenNoWindows = \s -> clickableWrap ((read s :: Int) - 1) ("  " ++ s ++ "  ")
    , ppUrgent          = \s -> clickableWrap ((read s :: Int) - 1) (xmobarBorder "Top" urgentColor 4 ("  " ++ s ++ "  "))
    , ppTitle           = id
    , ppSep             = " |  "
    , ppWsSep           = ""
    , ppLayout          = const ""
    }
  where
    foregroundColor = "#ffffff"
    backgroundColor = "#222222"
    urgentColor     = "#ff0000"

    -- Helper functions for DWM-like clickable workspaces
    clickableWrap :: Int -> String -> String
    clickableWrap index str = "<action=xdotool key super+" ++ show (index + 1) ++ ">" ++ str ++ "</action>"

    createDwmBox :: String -> String -> String
    createDwmBox color prefix = "<box type=HBoth offset=L20 color="++color++"><box type=Top mt=3 color="++color++"><box type=Top color="++color++">" ++ prefix ++ "</box></box></box>"

