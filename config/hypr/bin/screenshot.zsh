#!/usr/bin/env zsh
# Capture and edit a region screenshot to clipboard.

main() {
  set -eo pipefail

  # Check for core dependencies
  for cmd in slurp grim swappy wl-copy wl-paste; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: Required tool '$cmd' is not installed." >&2
      exit 1
    fi
  done

  wl-copy --clear

  # Grab region and pipe directly to swappy
  if grim -t ppm -g "$(slurp)" - | swappy -f -; then
    if [[ "$(wl-paste --list-types | grep -Fx 'image/png')" ]]; then
      # Use notify-send as a reliable fallback for dms toast
      if command -v notify-send &>/dev/null; then
        notify-send "Screenshot" "Copied screenshot to clipboard"
      fi
    fi
  else
    if command -v notify-send &>/dev/null; then
      notify-send "Screenshot" "Aborted"
    fi
  fi
}

main "$@"
