# Load the ZSH completion system using a custom path for the compiled cache file.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Use-of-compinit
autoload -Uz compinit
compinit -d $IGLOO_ZSH_PATH_CACHE/.zcompdump-$HOSTNAME-${ZSH_PATCHLEVEL:-$ZSH_VERSION}
