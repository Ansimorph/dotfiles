set fish_greeting # No Greeting
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/bg/bin"

# Imports
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/bin/setup-b2
/opt/homebrew/bin/rtx activate fish | source

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
abbr G.. 'cd (git rev-parse --show-toplevel || echo .)'
abbr v nvim
function sudobangbang --on-event fish_postexec
    abbr -g please sudo $argv[1]
end
