alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias y='xclip -selection clipboard -in'
alias p='xclip -selection clipboard -out'

alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'

if (( $+commands[exa] )); then
  alias exa="exa --group-directories-first --git";
  alias l="exa -blF";
  alias ll="exa -abghilmu";
  alias llm='ll --sort=modified'
  alias la="LC_COLLATE=C exa -ablF";
  alias tree='exa --tree'
fi

# creates a new directory and steps into it.
# parameters:
#   1. name - the name of the new directory
mkd() {
  mkdir -p "$@" && cd "${@:$#}"
}
