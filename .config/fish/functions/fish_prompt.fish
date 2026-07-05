function fish_prompt
    set -l __last_command_exit_status $status

    set -l red (set_color red)
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l black (set_color black)
    set -l normal (set_color normal)

    set -l oblong_color "$normal"
    if test $__last_command_exit_status != 0
        set oblong_color "$red"
    end

    set -l oblong "$oblong_color◼ "
    set -l prompt $normal'$'

    if fish_is_root_user
        set -l prompt $red'#'
    end

    set -l cwd $blue(prompt_pwd)
    set -l user_name $normal(whoami)
    set -l separator $black :

    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_char_dirtystate ◍
    set -g __fish_git_prompt_char_cleanstate $green ◍
    set -g __fish_git_prompt_color_dirtystate red
    set -g __fish_git_prompt_color normal
    set -g __fish_git_prompt_char_stagedstate ◍
    set -g __fish_git_prompt_color_stagedstate yellow

    set -l git (fish_git_prompt | string replace -r ' \((.*)\)' ' $1')
    echo -n -s $oblong $user_name $separator $cwd $git ' ' $prompt ' '
end
