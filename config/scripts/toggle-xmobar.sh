#!/bin/sh

if pgrep -f "xmobar.*x 0"; then
  pkill -f "xmobar.*x 0"
else
  xmobar -x 0 -d ~/.dotfiles/config/xmobar/xmobarrc &
fi

