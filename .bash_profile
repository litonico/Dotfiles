# set -o vi
eval "$(rbenv init - )"

alias ls='ls -G'
cd() { builtin cd "$@" && pwd && ls; }

get_git_branch()
{
    git branch 2> /dev/null |
    grep \* |
    sed "s/\*[[:space:]]//g" |
    sed "s/^/(/g" |
    sed "s/$/)/g"
}


# if [ -e /usr/share/terminfo/x/xterm-256color ]; then
#     export TERM='xterm-256color'
# else
#     export TERM='xterm-color'
# fi


export PS1="\u:\W\$(get_git_branch)\$ "

# Racket
PATH=$PATH:/Applications/Racket\ v6.1.1/bin:

alias r="rails"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
