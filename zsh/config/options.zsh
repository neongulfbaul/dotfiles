# Configure ZSH feature options.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html

# +--- Changing Directories ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Changing-Directories

# If a command is issued that can't be executed as a normal command, and the command is the name of a directory,
# perform the `cd` command to that directory.
setopt AUTO_CD

# Disable beep on an ambiguous completion.
setopt NO_LIST_BEEP

# +--- Expansion and Globbing ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Expansion-and-Globbing

# Treat the `#`, `~` and `^` characters as part of patterns for filename generation.
# Note that an initial unquoted `~` always produces named directory expansion.
setopt EXTENDED_GLOB

# Disable printing of errors if a pattern for filename generation has no matches.
setopt NO_NOMATCH

# Entirely disable error logging if a pattern for filename generation has no matches.
# Pattern that don't match are removed from the argument list instead.
# If no file matches a blank line is printed, with no error.
# Overrides the `NOMATCH` option.
setopt NULL_GLOB

# +--- Input/Output ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Input_002fOutput

# Allow comments even in interactive shells. 
setopt INTERACTIVE_COMMENTS

# +--- Job Control ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Job-Control

# Run all background jobs with the same priority as foreground tasks.
setopt NO_BG_NICE

# Disable immediately status reporting of background jobs to prevent messing up and reprinting the current line.
setopt NO_NOTIFY

# +--- Prompting ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Prompting

# Interpret percent escape sequences in prompt expansion.
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
setopt PROMPT_PERCENT

# Enable parameter expansion, command substitution and arithmetic expansion in prompts.
# Note that substitutions within prompts do not affect the command status. 
setopt PROMPT_SUBST

# +--- Shell Emulation ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Shell-Emulation

# Split on unquoted parameter expansions.
setopt SH_WORD_SPLIT

# +--- Zle ---+
# See:
#   1. http://zsh.sourceforge.net/Doc/Release/Options.html#Zle

# Disable beep on error in ZLE.
setopt NO_BEEP
