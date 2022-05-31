# Set the style of the sudo prompt.
# See:
#   1. sudo(8)
export SUDO_PROMPT=$(print -P "%B%F{0}%K{6}sudo%b%f%k %B%F{14}%n%b%f@%F{4}%m%f: ")
