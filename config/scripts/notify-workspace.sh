!/usr/bin/env bash

# Determine the currently focused workspace
ws=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')

# Append the workspace to the notifications file if not already present
grep -q "^$ws$" ~/.cache/xmobar/notifications || echo "$ws" >> ~/.cache/xmobar/notifications
