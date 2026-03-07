#!/usr/bin/env zsh

if [[ $TERM != dumb ]]; then
  export ZGEN_AUTOLOAD_COMPINIT=0

  # Interaction Tweaks
  WORDCHARS='-*?[]~&.;!#$%^(){}<>'
  setopt RC_QUOTES
  setopt COMBINING_CHARS
  setopt LONG_LIST_JOBS
  unsetopt BEEP

  # Path exports
  export KUBECONFIG="$HOME/.config/kube/config/k3s.yaml"

  # Plugin Env Vars
  export ZVM_INIT_MODE=sourcing
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  # Bootstrap zgenom
  if [[ ! -d "$ZGEN_DIR" ]]; then
    echo "Installing jandamm/zgenom"
    git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
  fi

  source $ZGEN_DIR/zgenom.zsh
  if ! zgenom saved; then
    echo "Initializing zgenom"
    # Nuke old cache if re-initing
    rm -f $ZDOTDIR/*.zwc(N) $XDG_CACHE_HOME/zsh/zcompdump*

    zgenom load junegunn/fzf shell
    zgenom load jeffreytse/zsh-vi-mode
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-completions src
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom load hlissner/zsh-autopair autopair.zsh

    zgenom save
    # FIXED: We no longer compile the whole $ZDOTDIR. 
    # Modern Zsh on NVMe doesn't need binary aliases.
  fi
  autopair-init
fi
