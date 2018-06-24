#!/usr/bin/env bash
######Other installs#####
# https://gist.github.com/DQNEO/67442bbe0c60f3220595

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
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# Some shortcuts for different directory listings
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -lF --color=auto'
alias la='ls -alF --color=auto'
alias l='ls -CF'
alias ls='ls -F'


# Make grep more user friendly by highlighting matches
alias grep='grep --color=auto'

alias glog='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

export DOCKER_SYNC_ENV_FILE=.env_docker-sync
export GIT_EMAIL=jraviotta@gmail.com
export GIT_NAME=Jonathan Raviotta
alias term='make terminus -- '
alias conda="$HOME/anaconda3/bin/conda"