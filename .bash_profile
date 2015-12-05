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
    sed "s/\*[[:space:]]//g" |
    sed "s/^/(/g" |
    sed "s/$/)/g"
}
export PS1="\u:\W\$(get_git_branch)\$ "

##### Carezone-specific #####
alias re_db='rake db:populate && rake db:migrate && rake db:test:prepare'

function sjrr() {
    re_db
    bundle exec specjour | script/rerun
}

##### Ruby ENV #####
export RUBY_GC_HEAP_INIT_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

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
