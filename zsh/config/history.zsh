# ZSH history configurations.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#index-history-2

# The path to the history file.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Parameters.html#index-HISTFILE
export HISTFILE=$IGLOO_ZSH_PATH_CACHE/history

# The maximum number of stored events.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Parameters.html#index-HISTSIZE
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE


# Each ZSH session appends it's history list to the history file, rather than replacing it.
setopt APPEND_HISTORY

# Save each command's beginning Unix timestamp and the duration in seconds.
setopt EXTENDED_HISTORY

# Remove the oldest history event that has a duplicate first before unique events when reaching the size limit.
setopt HIST_EXPIRE_DUPS_FIRST

# Hide duplicates of previous events when searching for history entries in the line editor.
setopt HIST_FIND_NO_DUPS

# Don't store events if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS

# Don't store events when the first character on the line is a space or when one of the expanded aliases contains
# a leading space.
# Note that the command is still kept in the internal history until the next command before it vanishes,
# allowing to briefly reuse or edit the line.
setopt HIST_IGNORE_SPACE

# Don't store function definitions.
# Note that the command is still kept in the internal history until the next command before it vanishes,
# allowing to briefly reuse or edit the line.
setopt HIST_NO_FUNCTIONS

# Remove superfluous blanks from events being added to the history list.
# This can also prevent duplicate entries when a previous event would not match in its untidied form.
# Note that the shell is smart enough not to remove blanks which are important, i.e. when quoted.
setopt HIST_REDUCE_BLANKS

# Don't store duplicate event at all, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# New history lines are added to `HISTFILE` incrementally as soon as they are entered,
# rather than waiting until the shell exits.
setopt INC_APPEND_HISTORY

# Disable beep in ZLE when a widget attempts to access a non-existing history entry.
setopt NO_HIST_BEEP
