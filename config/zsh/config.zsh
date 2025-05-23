#!/usr/bin/env zsh

# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
  unsetopt zle prompt_cr prompt_subst
  whence -w precmd >/dev/null && unfunction precmd
  whence -w preexec >/dev/null && unfunction preexec
  PS1='$ '
fi

## Bootstrap interactive session
if [[ $TERM != dumb ]]; then
  # Don't call compinit too early. I'll do it myself, at the right time.
  export ZGEN_AUTOLOAD_COMPINIT=0

  ## ZSH configuration
  if (( $+commands[bat] )); then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT='-c'
  fi

  # Treat these characters as part of a word.
  WORDCHARS='-*?[]~&.;!#$%^(){}<>'
  unsetopt BRACE_CCL        # Allow brace character class list expansion.
  setopt COMBINING_CHARS    # Combine zero-length punc chars (accents) with base char
  setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
  setopt HASH_LIST_ALL
  unsetopt CORRECT_ALL
  unsetopt NOMATCH
  unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.
  unsetopt BEEP             # Hush now, quiet now.
  setopt IGNOREEOF
  ## Jobs
  setopt LONG_LIST_JOBS     # List jobs in the long format by default.
  setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
  setopt NOTIFY             # Report status of background jobs immediately.
  unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
  unsetopt HUP              # Don't kill jobs on shell exit.
  unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
  ## History
  HISTORY_SUBSTRING_SEARCH_PREFIXED=1
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
 ## Directories
  DIRSTACKSIZE=9
  setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
  setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
  setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
  unsetopt PUSHD_TO_HOME      # Don't push to $HOME when no argument is given.
  setopt CDABLE_VARS          # Change directory to a path stored in a variable.
  setopt MULTIOS              # Write to multiple descriptors.
  unsetopt GLOB_DOTS
  unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list

  ## Plugin configuration
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_OPTS="--reverse --ansi"
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
  fi
  # zsh-vi-mode
  export ZVM_INIT_MODE=sourcing
  export ZVM_VI_ESCAPE_BINDKEY=^G
  export ZVM_LINE_INIT_MODE=i
  # zsh-autosuggest
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  #echo "ZGEN_DIR: $ZGEN_DIR"
  #echo "XDG_DATA_HOME: ${XDG_DATA_HOME:-not set}"
  #echo "PWD: $PWD"
  # kubernetes config file

  export KUBECONFIG=/home/neon/.config/kube/config/k3s.yaml



  ## Bootstrap zgenom
  export ZGEN_DIR="${ZGEN_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zgenom}"
  if [[ ! -d "$ZGEN_DIR" ]]; then
    # Use zgenom because zgen is no longer maintained
    echo "Installing jandamm/zgenom"
    git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
  fi

  source $ZGEN_DIR/zgenom.zsh
  zgenom autoupdate   # checks for updates every ~7 days
  if ! zgenom saved; then
    echo "Initializing zgenom"
    rm -frv $ZDOTDIR/*.zwc(N) \
            $ZDOTDIR/.*.zwc(N) \
            $XDG_CACHE_HOME/zsh \
            $ZGEN_INIT.zwc

    # Be extra careful about plugin load order, or subtle breakage can emerge.
    # This is the best order I've sussed out for these plugins.
    zgenom load junegunn/fzf shell
    zgenom load jeffreytse/zsh-vi-mode
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-completions src
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load dxrcy/zsh-history-substring-search
    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom load hlissner/zsh-autopair autopair.zsh

    zgenom save

    # Must be explicit because zgenom compile ignores nix-store symlinks
    zgenom compile \
      $ZDOTDIR/*(-.N) \
      $ZDOTDIR/.*(-.N) \
      $ZDOTDIR/completions/_*(-.N) \
      $DOTFILES_HOME/lib/zsh/*~*.zwc(.N)
  fi

  autopair-init

  # CD-able vars
  cfg=~/.config
fi
