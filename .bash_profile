eval "$(rbenv init - )"

# This helps vim break less often when using xterm-256
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

##### Aliases #####
alias vi="vim"
alias r="rails"
alias ls='ls -G'
cd() { builtin cd "$@" && pwd && ls; }
gem() # Make sure to `rbenv rehash` after every gem install
{
    if [ "$1" == "install" ] ; then
        shift
        /Users/Lito/.rbenv/shims/gem install "$@" && rbenv rehash
    else
        /Users/Lito/.rbenv/shims/gem "$@"
    fi
}



##### Command prompt #####
get_git_branch()
{
    git branch 2> /dev/null |
    grep \* |
    sed "s/\*[[:space:]]//g"
}
get_git_remote()
{
    basename 2> /dev/null -s .git \
        $(git remote -v 2> /dev/null |
          grep origin |
          grep fetch |
          awk '{print $2}')
}

export PS1="\u:\W(\[\033[32m\]\$(get_git_remote):\$(get_git_branch)\[\033[00m\])\$ "

##
fix() {
ls; clear; ls; clear;
}

##### PATH stuff #####
# Rbenv stupidity
export PATH="~/.rbenv/shims:$PATH"

# Brew linking
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/lib"

# Racket
PATH=$PATH:/Applications/Racket\ v6.1.1/bin:

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export CDPATH=":~/Projects:~/Problems_and_Practice"

# Brew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
source ~/.git-completion.bash
