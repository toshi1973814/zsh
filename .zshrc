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
plugins=(rails git)

source $ZSH/oh-my-zsh.sh

export LANG=ja_JP.UTF-8

export PATH=/usr/local/bin:$PATH:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
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

export HISTTIMEFORMAT="%F %T "

export PATH=/usr/local/mysql/bin:$PATH

export EDITOR=/usr/bin/vim

alias cd_coore="cd ~/work/rails_projects/coore_on_rails"
alias tailf="tail -f"
function tree {
find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

cd_coore

export _CUSTOMER_EMAIL_FOR_SPEC='yasuda@coobal.co.jp'

#source ~/.bash/git-prompt
#PS1="\u@\h:\W\$(parse_git_branch_or_tag) $ "

eval "$(rbenv init - --no-rehash)"
#alias ctags="`brew --prefix`/bin/ctags -R --exclude=.git --exclude=log *"
alias ctags="ctags -R --exclude=.git --exclude=log *"
alias pbcopy="nkf -w | __CF_USER_TEXT_ENCODING=0x$(printf %x $(id -u)):0x08000100:14 pbcopy"

# https://gist.github.com/lunchub/6636906
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000
alias tmux='tmux -u'

export VAGRANT_LOG=debug

# git
alias git_up="git commit -m'update coore_on_rails revision'"
alias git_mg="git commit -m'manual merge on Gemfile.lock'"
alias git_head="git rev-parse HEAD"
git_branch_with_date() { for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r }
alias gl="git log --pretty=format:\"%h - %an, %ar : %s\" --graph"
alias git_rm_all="git status | perl -nlaF'\s+' -e'$F[1] eq \"deleted:\" and print $F[2];' | xargs git rm"
#alias egl="git log -n3"

# checking out git branch and switching database setting at once
git_co_ex() {
  if [ "$#" -ne 2 ]
  then
    echo "specify branch_name, database_symbol"
    echo ""
    cat "$(pwd)/branch_and_database_yml"
  else
    git checkout $1
    ln -sf "$(pwd)/config/database.$2.yml" "$(pwd)/config/database.yml"
    echo "$1 $2" > "$(pwd)/branch_and_database_yml"
  fi
}

export HIST_STAMPS="dd.mm.yyyy"
#alias rsq="bin/rake resque:work QUEUE='*' &"
#alias rsqw="bin/resque-web"

# capistrano
cap_depl() { cap $1 deploy -S revision=`git rev-parse HEAD`}
cap_migr() { cap $1 deploy:migrations -S revision=`git rev-parse HEAD`}
cap_rest() { cap $1 deploy:restart}

#alias mysqld="sudo /usr/local/opt/mysql/bin/mysqld_safe --bind-address=127.0.0.1 &"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

# mysql
multi_mysqld() { sudo /usr/local/Cellar/mysql/5.6.14/bin/mysqld_multi $1 --mysqld=mysqld_safe }

# http://naleid.com/blog/2011/03/05/running-redis-as-a-user-daemon-on-osx-with-launchd
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

# god
alias restart_god="bundle exec god terminate && bundle exec god && bundle exec god load config/god/development.god && bundle exec god start"
