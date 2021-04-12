# ZSH plugins managed by zplug.
# See:
#   1. https://github.com/zplug/zplug
[[ -f $ZDOTDIR/lib/plugins-base.zsh ]] && source $ZDOTDIR/lib/plugins-base.zsh

zplug "usr/share/fzf", \
  from:local, \
  if:"type fzf > /dev/null && [[ -d usr/share/fzf ]]", \
  use:"{completion,key-bindings}.zsh"

# Load all plugins and add commands to the executable search path.
zplug load
