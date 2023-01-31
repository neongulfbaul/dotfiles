# Tie (`-T`) the `FPATH` environment variable for unique (`-U`) entries.
# Extend the ZSH function search path where system-wide functions should always take precedence.
#export -TU FPATH fpath
#fpath=($fpath $ZDOTDIR/lib/functions $ZDOTDIR/lib/themes $PATH_USER_FUNC)

# Tie (`-T`) the `INFOPATH` environment variable for unique (`-U`) entries.
# Extend the info search path where user-level manuals should always take precedence.
#export -TU INFOPATH infopath
#infopath=($PATH_USER_INFO $infopath)

# Tie (`-T`) the `MANPATH` environment variable for unique (`-U`) entries.
# Extend the manual search path where user-level manuals should always take precedence.
#export -TU MANPATH manpath
#manpath=($PATH_USER_MAN $manpath)

# Tie (`-T`) the `PATH` environment variable for unique (`-U`) entries.
# Extend the executable search path where user-level applications should always take precedence.
#export -TU PATH path
#path=($PATH_USER_BIN $path)

# Load custom configurations.
[[ -f $ZDOTDIR/lib/config.zsh ]] && source $ZDOTDIR/lib/config.zsh

# Load package environment variables.
function {
  local pkg_env
  for pkg_env ($ZDOTDIR/pkgs/**/env.zsh) source $pkg_env
}

# Load all ZSH related configurations.
[[ -f $ZDOTDIR/config/history.zsh ]] && source $ZDOTDIR/config/history.zsh
[[ -f $ZDOTDIR/config/options.zsh ]] && source $ZDOTDIR/config/options.zsh
[[ -f $ZDOTDIR/config/zle.zsh ]] && source $ZDOTDIR/config/zle.zsh

# Load all package configurations and aliases.
function {
  local pkg_aliases pkg_config
  for pkg_aliases ($ZDOTDIR/pkgs/**/aliases.zsh) source $pkg_aliases
  for pkg_config ($ZDOTDIR/pkgs/**/config.zsh) source $pkg_config
}

# Autoload all custom functions.
function {
  local lib_func
  for lib_func ($ZDOTDIR/lib/functions/**/*) autoload -Uz $lib_func
}

# Enable Promptinit
autoload -Uz promptinit
promptinit

# Set the prompt theme.
prompt $ZSH_PROMPT_THEME_NAME

# Load the ZSH line editor key bindings.
[[ -f $ZDOTDIR/lib/key-bindings.zsh ]] && source $ZDOTDIR/lib/key-bindings.zsh

# Load and setup ZSH plugins with zplug.
[[ -f $ZDOTDIR/lib/plugins.zsh ]] && source $ZDOTDIR/lib/plugins.zsh
