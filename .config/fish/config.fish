# Imports
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/bin/setup-env
fzf --fish | source
mise activate fish | source

# Aliases
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias e="$EDITOR"
alias m="aerc"
abbr serve "python3 -m http.server 8080"
abbr G.. "cd (git rev-parse --show-toplevel || echo .)"
