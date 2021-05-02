# Enable and initialize ZSH's prompt theme and configuration support.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Prompt-Themes
autoload -Uz vcs_info
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors
