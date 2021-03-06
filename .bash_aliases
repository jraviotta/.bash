#######################################################
####################   Aliases  #######################
#######################################################
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep'              # show differences in colour
alias fgrep='fgrep'              # show differences in colour
alias ifconfig='ip -stats -color -human addr'

# Some shortcuts for different directory listings
alias dir='ls --format=vertical'
alias vdir='ls --format=long'
alias ll='ls -lF'
alias lsa='ls -alF'
alias l='ls -CF'
alias ls='ls -F'

# Git
# Make pretty git log for cli
alias glog='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
function git() { case $* in fetch* ) shift 1; command git fetch "$@" --prune ;; * ) command git "$@" ;; esac }

# Tools
if grep -q Microsoft /proc/version; then
    echo 'Creating Windows aliases'
	alias lando='/mnt/c/Windows/System32/cmd.exe /c "lando"'
    alias drush='/mnt/c/Windows/System32/cmd.exe /c "lando drush --y"'
    alias brave-browser="'/mnt/c/Program Files (x86)/BraveSoftware/Brave-Browser/Application/brave.exe'"
fi

# SSH
# open port to local jupyter
alias ssh-jupyter="ssh -N -C -q -f -L 9999:localhost:8888 jona@192.168.1.79"
alias ssh-jupyter-remote="ssh -N -C -q -f -L localhost:8888:localhost:9999 jona@jraviotta.asuscomm.com -p 22022"
#alias ssh-whopper-pf="ssh -D 4000 -f -C -q -N jona@jraviotta.asuscomm.com -p 22022"
# login to whopper
alias ssh-whopper="ssh jona@192.168.1.79"
alias ssh-whopper-remote="ssh jona@jraviotta.asuscomm.com -p 22022"

# Lando
alias drush='lando drush --yes'
alias composer='lando composer'
alias behat='lando behat'

# Python
alias activate="source env/bin/activate"

# Docker
alias airflow="docker exec -ti airflow airflow"
