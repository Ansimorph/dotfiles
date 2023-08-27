# No Greeting
set fish_greeting

# PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/bg/bin"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# B2 Variables
source ~/bin/setup-b2

# ASDF
source (brew --prefix asdf)/libexec/asdf.fish

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
abbr G.. 'cd (git rev-parse --show-toplevel || echo .)'
abbr v nvim
function sudobangbang --on-event fish_postexec
    abbr -g please sudo $argv[1]
end
