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
plugins=(git)

source $ZSH/oh-my-zsh.sh

export LANG=ja_JP.UTF-8

export PATH=$PATH:/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
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

alias git_rm_all="git status | perl -nlaF'\s+' -e'$F[1] eq \"deleted:\" and print $F[2];' | xargs git rm"
cd_coore

export _CUSTOMER_EMAIL_FOR_SPEC='yasuda@coobal.co.jp'

#source ~/.bash/git-prompt
#PS1="\u@\h:\W\$(parse_git_branch_or_tag) $ "

alias gl="git log --pretty=format:\"%h - %an, %ar : %s\" --graph"
eval "$(rbenv init - --no-rehash)"
alias ctags="`brew --prefix`/bin/ctags"
alias pbcopy="nkf -w | __CF_USER_TEXT_ENCODING=0x$(printf %x $(id -u)):0x08000100:14 pbcopy"
alias egl="git log -n3"

# https://gist.github.com/lunchub/6636906
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000
alias tmux='tmux -u'

export VAGRANT_LOG=debug

alias git_up="git commit -m'update coore_on_rails revision'"

export HIST_STAMPS="dd.mm.yyyy"
#alias rsq="bin/rake resque:work QUEUE='*' &"
#alias rsqw="bin/resque-web"
alias git_head="git rev-parse HEAD"
cap_depl() { cap $1 deploy -S revision=`git rev-parse HEAD`}
cap_migr() { cap $1 deploy:migrations -S revision=`git rev-parse HEAD`}
cap_rest() { cap $1 deploy:restart}

alias mysqld="sudo /usr/local/opt/mysql/bin/mysqld_safe --bind-address=127.0.0.1 &"
