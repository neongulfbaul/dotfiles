#!/bin/sh
im=$(fcitx5-remote)
case "$im" in
  1) echo "EN" ;;
  2) echo "あ" ;;
  *) echo "--" ;;
esac
