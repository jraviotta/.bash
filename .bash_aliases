#######################################################
####################   Aliases  #######################
#######################################################
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
if [[ $HOST == "darwin" ]]; then COLOR="-G"; else COLOR="--color=auto"; fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
alias grep='grep $COLOR'                     # show differences in colour
alias egrep='egrep $COLOR'              # show differences in colour
alias fgrep='fgrep $COLOR'              # show differences in colour
alias ifconfig='ip -stats -color -human addr'

# Some shortcuts for different directory listings
alias ls='ls $COLOR'
alias lsa='ls -A $COLOR'
alias ll='ls --format=long $COLOR'
alias lla='ls -alF $COLOR'

# Git
# Make pretty git log for cli
alias glog='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
function git() { case $* in fetch* ) shift 1; command git fetch "$@" --prune ;; * ) command git "$@" ;; esac }

# Tools
# TODO: update for WSL
## Lando
if [ "$HOST" == "windows" ]; then
    echo 'Creating Windows aliases'
	alias lando='/mnt/c/Windows/System32/cmd.exe /c "lando"'
    alias drush='/mnt/c/Windows/System32/cmd.exe /c "lando drush --y"'
    alias composer='/mnt/c/Windows/System32/cmd.exe /c "lando composer"'
    alias behat='/mnt/c/Windows/System32/cmd.exe /c "lando behat"'

elif [ "$HOST" == "linux-gnu" ] || [ "$HOST" == "darwin" ] ; then
    # Lando
    alias drush='lando drush --yes'
    alias composer='lando composer'
    alias behat='lando behat'

    # Python
    alias activate="source .venv/bin/activate"

    # Docker
    alias airflow="docker exec -ti airflow airflow"

    # pbcopy
    if [ $HOST == 'linux-gnu' ]; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    fi
fi

# SSH
# open port to local jupyter
# alias ssh-jupyter="ssh -N -C -q -f -L 9999:localhost:8888 jona@192.168.1.79"
# alias ssh-jupyter-remote="ssh -N -C -q -f -L localhost:8888:localhost:9999 jona@jraviotta.asuscomm.com -p 22022"
# #alias ssh-whopper-pf="ssh -D 4000 -f -C -q -N jona@jraviotta.asuscomm.com -p 22022"
# # login to whopper
# alias ssh-whopper="ssh jona@192.168.1.79"
# alias ssh-whopper-remote="ssh jona@jraviotta.asuscomm.com -p 22022"
# # PHSNL
# alias ssh-pace="ssh -L 127.0.0.1:10432:localhost:5432 jmr154@130.49.206.138"
