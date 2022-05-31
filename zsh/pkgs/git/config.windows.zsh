# Configurations for Git, the free and open source distributed version control system.
# See:
#   1. https://git-scm.com

# Load the official prompt support script that is bundled with Git.
# See:
#   1. https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
#   2. https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
if [[ -f /usr/local/opt/git/etc/bash_completion.d/git-prompt.sh ]]; then
  source /usr/local/opt/git/etc/bash_completion.d/git-prompt.sh
  [[ -f $ZDOTDIR/pkgs/git/config-base.zsh ]] && source $ZDOTDIR/pkgs/git/config-base.zsh
fi
