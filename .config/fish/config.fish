# Imports
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/bin/setup-b2

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias e="$EDITOR"
abbr G.. 'cd (git rev-parse --show-toplevel || echo .)'
