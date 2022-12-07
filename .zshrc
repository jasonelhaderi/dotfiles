########################################################################
# PROMPT CONFIG
########################################################################

# Main prompt.
PROMPT='%B%F{39}%1~%f%b %# '

# Set up right-hand prompt with git info.
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{39}(%b)%f'
zstyle ':vcs_info:*' enable git

########################################################################
# HISTORY and MISC OPTIONS
########################################################################

# Make Globbing case-insensitive.
setopt NO_CASE_GLOB

# Make globbing cycle through completions with tab instead of replacing.
setopt GLOB_COMPLETE

# Set auto cd.
setopt AUTO_CD

# Allow emacs keybindings.
bindkey -e

# Set up history file.
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000

# Share history across sessions and append commands rather than overwrite.
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Update history after each command rather than on shell exit.
setopt INC_APPEND_HISTORY

# Some conveniences to make the command history a bit nicer.
# Some are redudant; so choose which ones you want to have uncommented.
setopt HIST_EXPIRE_DUPS_FIRST
# setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Make history substitution require verification before execution.
setopt HIST_VERIFY

# Some history search goodies to integrate up and down arrow.
bindkey '^[[A' up-line-or-search # up arrow bindkey
bindkey '^[[B' down-line-or-search # down arrow

# Enable command correction. CORRECT_ALL tries to correct an entire line
# whereas CORRECT only tries to correct the command.
setopt CORRECT_ALL

########################################################################
# MISC ALIASES
########################################################################

alias -g ll='ls -laGFh'

########################################################################
# DOTFILE MANAGEMENT
########################################################################

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

########################################################################
# HOMEBREW
########################################################################

# Functions to help brew and conda play nicer with each other.
function detatch_conda () {
  #echo "Removing conda from path..."
  PATH=$(echo $PATH | sed -E "s/\/Users\/$(whoami)\/miniconda3\/(bin|condabin):?//g")
  #echo "Done."
}

function attach_conda () {
  #echo "Adding conda to path..."
  PATH="/Users/$(whoami)/miniconda3/bin:/Users/$(whoami)/miniconda3/condabin:"$(echo $PATH)
  #echo "Done."
}

brew () {
  detatch_conda
  command brew "$@"
  attach_conda
}

# Alias for maintenence of homebrew.
alias -g brewup='brew update; brew upgrade; brew cleanup; brew doctor'

# Including homebrew's sbin in the PATH.
PATH="/usr/local/sbin:$PATH"

# Include homebrew's new location in MacOS 11+ in PATH.
PATH="/opt/homebrew/bin:$PATH"

# Include homebrew's new sbin location in MacOS 13+ in PATH
PATH="/opt/homebrew/sbin:$PATH"
########################################################################
# DUMB TERMINAL CONFIG
########################################################################

if [ "dumb" = "$TERM" ] ; then
    alias less='cat'
    alias more='cat'
    export PAGER='cat'
    export TERM=xterm-color
    export PROMPT=$(echo "%B%F{24}%1~ ${RPROMPT}%f%b %# ")
    export RPROMPT=''
fi

########################################################################
# AUTOMATICALLY ADDED TO ZSHRC; DO NOT ADD MANUALLY ADD BELOW HERE
########################################################################

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l \(%p\)%s
zstyle :compinstall filename '/Users/$(whoami)/.zshrc'

autoload -Uz compinit && compinit
# End of lines added by compinstall

########################################################################
# MINICONDA install
########################################################################

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/$(whoami)/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/$(whoami)/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/$(whoami)/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/$(whoami)/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f "/Users/$(whoami)/.ghcup/env" ] && source "/Users/$(whoami)/.ghcup/env" # ghcup-env

########################################################################
# NVM CONFIG
########################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load Angular CLI autocompletion.
source <(ng completion script)
