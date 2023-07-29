# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# dirs: blue, not bold
export LS_COLORS=$LS_COLORS:"di=34"
alias ls='ls --color=auto'

# Switch cursor between beam and block depending on terminal Vim mode
BLOCK='\e[1 q'
BEAM='\e[5 q'

function zle-line-init zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne $BLOCK
  elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] ||
       [[ $KEYMAP = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne $BEAM
  fi
}

zle -N zle-line-init
zle -N zle-keymap-select

bindkey '^R' history-incremental-search-backward

# Remove delay when switching Vim mode
export KEYTIMEOUT=1

# PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/bg/bin"
fpath=(/usr/local/share/zsh-completions $fpath)

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# B2 Variables
source ~/bin/setup-b2

# Aliases
alias please='sudo $(fc -ln -1)'
alias v='nvim'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

