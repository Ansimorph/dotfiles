function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_arrow_functions_defined
        set -g __fish_arrow_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD 2>/dev/null)
            end
        end

        function _is_git_dirty
            not command git diff-index --cached --quiet HEAD -- &>/dev/null
            or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
        end

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end
    end

    set -l cyan (set_color cyan)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l brblack (set_color brblack)
    set -l normal (set_color normal)

    set -l arrow_color "$normal"
    if test $__last_command_exit_status != 0
        set arrow_color "$red"
    end

    set -l oblong "$arrow_color◼ "
    set -l prompt $normal'$'

    if fish_is_root_user
        set -l prompt $red'#'
    end

    set -l cwd $blue(prompt_pwd)
    set -l user_name $normal(whoami)
    set -l separator $brblack :

    set -l repo_info
    if _is_git_repo
        set repo_info $normal(_git_branch_name)

        set -l repo_status

        if _is_git_dirty
            set repo_status "$red ◍"
        else
            set repo_status "$green ◍"
        end

        set repo_info ' ' "$repo_info$repo_status"
    end

    echo -n -s $oblong $user_name $separator $cwd $repo_info ' ' $prompt ' '
end
