# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="juanghurtado"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git)
plugins=(rails git bundler common-aliases autojump)

source $ZSH/oh-my-zsh.sh

export LANG=ja_JP.UTF-8

export PATH=/usr/local/bin:$PATH:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/Applications
# eval "$(rbenv init -)"

HISTSIZE=10000
export HISTSIZE

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
     /usr/bin/ssh-add ~/.ssh/rsa;
     /usr/bin/ssh-add ~/.ssh/rsa-coore-on-rails;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

if ! ps aux | grep 65001 | grep -q "git.s-rep.net"; then
  echo "creating port fowarding connection..."
  nohup ssh -nNT -R 172.31.27.180:65001:localhost:5990 git.s-rep.net > /dev/null 2>&1 &
fi

export HISTTIMEFORMAT="%F %T "

export PATH=/usr/local/mysql/bin:$PATH

# alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
export EDITOR=vim

alias cd_coore="cd ~/work/rails_projects/coore_on_rails"
alias tailf="tail -f"
function tree {
find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

export _CUSTOMER_EMAIL_FOR_SPEC='yasuda@coobal.co.jp'
export RAILS_ASSETS_DEBUG=false
export RAILS_PERFORM_CACHING=true
export ACTIVE_ADMIN_FAVICON='favicons/active_admin_favicon_local.ico'

#source ~/.bash/git-prompt
#PS1="\u@\h:\W\$(parse_git_branch_or_tag) $ "

eval "$(rbenv init - --no-rehash)"
#alias ctags="`brew --prefix`/bin/ctags -R --exclude=.git --exclude=log *"
alias ctags="ctags -R --exclude=.git --exclude=log *"
alias pbcopy="nkf -w | __CF_USER_TEXT_ENCODING=0x$(printf %x $(id -u)):0x08000100:14 pbcopy"

# https://gist.github.com/lunchub/6636906
RUBY_GC_MALLOC_LIMIT=67108864
RUBY_GC_MALLOC_LIMIT_MAX=134217728
#RUBY_GC_MALLOC_LIMIT=33554432
#RUBY_GC_MALLOC_LIMIT_MAX=67108864
#RUBY_GC_MALLOC_LIMIT=16777216
#RUBY_GC_MALLOC_LIMIT_MAX=33554432
RUBY_GC_MALLOC_LIMIT_GROWTH_FACTOR=1.8
alias tmux='tmux -u'

export VAGRANT_LOG=debug

# git
alias gcup="git commit -m'update coore_on_rails revision'"
alias gitmg="git commit -m'manual merge'"
alias grph="git rev-parse HEAD"
git_branch_with_date() { for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r }
alias gL="git log"
alias glp="git log --pretty=format:\"%h - %an, %ar : %s\" --graph"
alias git_rm_all="git status | perl -nlaF'\s+' -e'$F[1] eq \"deleted:\" and print $F[2];' | xargs git rm"
alias gch='gc -C HEAD -e'
#alias egl="git log -n3"
ignore_option="--ignore-space-at-eol"
alias gac='ga .'
alias gsn='git show --name-only'
alias ggr='git grep'
alias glS='git log -S'
alias gs='git show'
alias gcch='git commit -CHEAD -e'
alias glmine='glola --author=yasuda'

# checking out git branch and switching database setting at once
#git_co_ex() {
  #if [ "$#" -ne 2 ]
  #then
    #echo "specify branch_name database_symbol"
    #echo ""
    #cat "$(pwd)/config/database.yml.current"
  #else
    #git checkout $1
    #ln -sf "$(pwd)/config/database.yml.$2" "$(pwd)/config/database.yml"
    #echo "$1 $2" > "$(pwd)/config/database.yml.current"
    #echo ""
    #cat "$(pwd)/config/database.yml.current"
  #fi
#}
gcom() {
  if [ -z "$1" ]; then echo "branch is unset"; fi
	gco $1
  if [ ${PWD##*/} = "coore_on_rails" ]
    then kmy; remy
  elif [ ${PWD##*/} = "hybrid_on_rails" ]
    then kmy; remyr
    # else rdm
  fi
}

gcr() {
  git commit -m"redmine #${1}" -e
}

export HIST_STAMPS="dd.mm.yyyy"
#alias rsq="bin/rake resque:work QUEUE='*' &"
#alias rsqw="bin/resque-web"

# capistrano
#cap_depl() { cap $1 deploy -S revision=`git rev-parse HEAD` && cap $1 log:tail}
#cap_migr() { cap $1 deploy:migrations -S revision=`git rev-parse HEAD` && cap $1 log:tail}
#cap_rest() { cap $1 deploy:restart && cap $1 log:tail}
cap_depl() { cap $1 deploy -S revision=`git rev-parse HEAD`}
cap_migr() { cap $1 deploy:migrations -S revision=`git rev-parse HEAD`}
cap_rest() { cap $1 deploy:restart}
cap_log() { cap $1 log:tail}

cader() { cap responsive-develop0$1 deploy -S revision=`git rev-parse HEAD`}
camir() { cap responsive-develop0$1 deploy:migrations -S revision=`git rev-parse HEAD`}
carer() { cap responsive-develop0$1 deploy:restart}
calor() { cap responsive-develop0$1 log:tail}

caded() { cap develop0$1 deploy -S revision=`git rev-parse HEAD`}
camid() { cap develop0$1 deploy:migrations -S revision=`git rev-parse HEAD`}
cared() { cap develop0$1 deploy:restart}
calod() { cap develop0$1 log:tail}

#alias mysqld="sudo /usr/local/opt/mysql/bin/mysqld_safe --bind-address=127.0.0.1 &"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

# mysql
# multi_mysqld() { sudo /usr/local/Cellar/mysql/5.6.14/bin/mysqld_multi $1 --mysqld=mysqld_safe }
multi_mysqld() { sudo /usr/local/Cellar/mysql/5.6.14/bin/mysqld_multi $1 }
alias vimy="sudo vim /etc/my.cnf"
# alias remy="sudo killall -v -m mysqld; sudo mysqld_safe &"
alias kmy="sudo killall -v -m mysqld"
function fetch_repository_name {
  git config -l | perl -wnl -e'/remote\.origin\.url.*\/(.+)\.git/ and print $1'
}
alias remyr='sudo mysqld_safe --datadir=/usr/local/var/`fetch_repository_name`_`git name-rev --name-only HEAD` &'
# http://stackoverflow.com/questions/16232931/bash-cached-command-result-in-alias
alias remy='sudo mysqld_safe --datadir=/usr/local/var/`git name-rev --name-only HEAD` &'
alias psmy="ps aux | grep mysqld"

# http://naleid.com/blog/2011/03/05/running-redis-as-a-user-daemon-on-osx-with-launchd
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

# god
alias restart_god="bundle exec god terminate && bundle exec god && bundle exec god load config/god/development.god && bundle exec god start"
alias start_god="bundle exec god && bundle exec god load config/god/development.god && bundle exec god start"

# https://robots.thoughtbot.com/how-to-copy-and-paste-with-tmux-on-mac-os-x
copy_buffer_to_osx() {
  while true; do
    if test -n "`tmux showb 2> /dev/null`"; then
      tmux saveb -|pbcopy && tmux deleteb
    fi
    sleep 0.5
  done &
}

# https://www-s.acm.illinois.edu/workshops/zsh/dir_stack.html
export DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'
alias cp='cp'
alias krs="pkill -9 -f 'rails server'"
alias ram='rake apartment:migrate'
alias rar='rake apartment:rollback'
alias buc='bundle update coore_on_rails'
alias agr="alias | grep"
alias hgr="history | grep"
alias cdco='cd ~/work/rails_projects/coore_on_rails'
alias cdcl='cd ~/work/rails_projects/cloud_on_rails'
alias cdre='cd ~/work/rails_projects/responsive_on_rails'
alias rzsh='. ~/.zshrc'
cdbs() {
  cd $(bundle show "$1")
}
