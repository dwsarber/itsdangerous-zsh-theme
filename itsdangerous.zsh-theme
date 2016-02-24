function is_git_repo {
    git branch >/dev/null 2>/dev/null
}

function get_git_branch_name {
    git symbolic-ref --short HEAD 2>/dev/null
}

function git_branch_char {
    is_git_repo && [[ $(get_git_branch_name) != "master" ]] && echo '╠╝' && return
    is_git_repo && [[ $(get_git_branch_name) == "master" ]] && echo '║' && return
}

function git_more_del {
    local add=$(git diff --numstat | awk 'NF==3 {plus+=$1; minus+=$2} END {printf(plus)}')
    local del=$(git diff --numstat | awk 'NF==3 {plus+=$1; minus+=$2} END {printf(minus)}')

    [[ add -lt del ]]
}

function git_differences_count {
    git diff --numstat | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'
}

function git_differences_char {
    is_git_repo && [[ $(git_more_del) ]] && return '%{$fg_bold[green]%}$(git_differences_count)'
    is_git_repo && [[ ! $(git_more_del) ]] && return '%{$fg_bold[red]%}$(git_differences_count)'
}

PROMPT='%{$fg_bold[yellow]%}[ %n ∩ %m ] %{$fg_bold[green]%}in %1~ %{$fg_bold[blue]%}$(git_prompt_info) %{$fg[red]%}$(git_branch_char) %{$reset_color%}
%{$fg_bold[yellow]%}λ % %{$reset_color%}'

local ret_status="%(?:%{$fg_bold[green]%}♪ :%{$fg_bold[red]%}☠ %s)"
RPROMPT='${ret_status} %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="#git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
