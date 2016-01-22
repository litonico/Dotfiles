source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

source ~/git-completion.bash

# This may help vim break less often when using xterm-256?
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi


##### Aliases #####
alias vi="vim"
alias r="rails"
alias ls='ls -G'
alias ag='ag --path-to-agignore=~/.agignore'
cd() { builtin cd "$@" && pwd && ls; }

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

##### Carezone-specific #####
alias re_db='rake db:populate && rake db:migrate && rake db:test:prepare'
alias railstests='bundle exec rspec --exclude-pattern "spec/feature/*"'
alias rspec='bundle exec \rspec'
alias rake='bundle exec \rake'
alias deploy='rake deploy:i_feel_lucky'
alias cw='cd ~/CareZone/careflow'

function sjrr() {
    re_db
    bundle exec specjour | script/rerun
}

##### Fix curses when switching between vim and the terminal #####
fix() { clear; ls; clear; ls; clear; }

export ARCHFLAGS="-arch x86_64"

# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# Uncomment to persist pair info between terminal instances
# hitch
