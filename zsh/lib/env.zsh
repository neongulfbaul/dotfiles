# Custom variables for XDG base directories to support OS that don't adhere to the specifications like macOS.
export PATH_USER_CACHE="${PATH_USER_CACHE:-$HOME/.cache}"
export PATH_USER_CONFIG="${PATH_USER_CONFIG:-$HOME/.config}"
export PATH_USER_DATA="${PATH_USER_DATA:-$HOME/.local/share}"
export PATH_USER_BIN=$HOME/.local/bin
export PATH_USER_FUNC=$HOME/.local/functions
export PATH_USER_INFO="${PATH_USER_INFO:-$IGLOO_PATH_USER_DATA/info}"
export PATH_USER_MAN="${PATH_USER_MAN:-$IGLOO_PATH_USER_DATA/man}"

# Custom variables for XDG user directories to support OS that don't adhere to the specifications like macOS.
export PATH_USER_DESKTOP="${PATH_USER_DESKTOP:-${XDG_DESKTOP_DIR:-HOME/desktop}}"
export PATH_USER_DOCUMENTS="${PATH_USER_DOCUMENTS:-${XDG_DOCUMENTS_DIR:-HOME/documents}}"
export PATH_USER_DOWNLOADS="${PATH_USER_DOWNLOADS:-${XDG_DOWNLOAD_DIR:-HOME/downloads}}"
export PATH_USER_MUSIC="${PATH_USER_MUSIC:-${XDG_MUSIC_DIR:-HOME/music}}"
export PATH_USER_IMAGES="${PATH_USER_IMAGES:-${XDG_PICTURES_DIR:-HOME/images}}"
export PATH_USER_TEMPLATES="${PATH_USER_TEMPLATES:-${XDG_TEMPLATES_DIR:-HOME/code/snippetbox/gists}}"
export PATH_USER_VIDEOS="${PATH_USER_VIDEOS:-${XDG_VIDEOS_DIR:-HOME/videos}}"

# The custom path for the ZSH cache directory.
export ZSH_PATH_CACHE=$IGLOO_PATH_USER_CACHE/zsh

# The name of the ZSH prompt theme.
export ZSH_PROMPT_THEME_NAME="${ZSH_PROMPT_THEME_NAME:-igloo}"

# Allows to disable support for 24-bit colors ("true color").
# This variable is read for different configurations in order to disable the usage of HEX triplets
# when specifying colors for prompts and line editor highlighting.
export ZSH_NO_TRUE_COLOR="${ZSH_NO_TRUE_COLOR:-false}"

# Set basic configurations for Unix core applications and commands.
export LANG=${LANG:-en_US.UTF-8}
export LC_MESSAGES=${LC_MESSAGES:-POSIX}
if type vim > /dev/null; then
  export EDITOR="vim"
  export MANPAGER="vim -R +MANPAGER -"
  export VISUAL="vim"
fi
