
#!/bin/bash
################# Shell Options #######################
### See man bash for more options...                ###
#######################################################
# ~/.bashrc: executed by bash for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
set -o ignoreeof

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Include dotfiles in glob operations
shopt -s dotglob

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#######################################################
##################  Colors  ###########################
#######################################################
# Reset
# Color_Off='\e[0m'       # Text Reset
reset="$(tput sgr0)"

# Regular Colors
fg_black="$(tput setaf 0)"
fg_red="$(tput setaf 1)"
fg_green="$(tput setaf 2)"
fg_yellow="$(tput setaf 3)"
fg_blue="$(tput setaf 4)"
fg_magenta="$(tput setaf 5)"
fg_cyan="$(tput setaf 6)"
fg_white="$(tput setaf 7)"

# # Bold
# BBlack='\e[1;30m'       # Black
# BRed='\e[1;31m'         # Red
# BGreen='\e[1;32m'       # Green
# BYellow='\e[1;33m'      # Yellow
# BBlue='\e[1;34m'        # Blue
# BPurple='\e[1;35m'      # Purple
# BCyan='\e[1;36m'        # Cyan
# BWhite='\e[1;37m'       # White

# # Underline
# UBlack='\e[4;30m'       # Black
# URed='\e[4;31m'         # Red
# UGreen='\e[4;32m'       # Green
# UYellow='\e[4;33m'      # Yellow
# UBlue='\e[4;34m'        # Blue
# UPurple='\e[4;35m'      # Purple
# UCyan='\e[4;36m'        # Cyan
# UWhite='\e[4;37m'       # White

# # Background
# On_Black='\e[40m'       # Black
# On_Red='\e[41m'         # Red
# On_Green='\e[42m'       # Green
# On_Yellow='\e[43m'      # Yellow
# On_Blue='\e[44m'        # Blue
# On_Purple='\e[45m'      # Purple
# On_Cyan='\e[46m'        # Cyan
# On_White='\e[47m'       # White

# # High Intensity
# IBlack='\e[0;90m'       # Black
# IRed='\e[0;91m'         # Red
# IGreen='\e[0;92m'       # Green
# IYellow='\e[0;93m'      # Yellow
# IBlue='\e[0;94m'        # Blue
# IPurple='\e[0;95m'      # Purple
# ICyan='\e[0;96m'        # Cyan
# IWhite='\e[0;97m'       # White

# # Bold High Intensity
# BIBlack='\e[1;90m'      # Black
# BIRed='\e[1;91m'        # Red
# BIGreen='\e[1;92m'      # Green
# BIYellow='\e[1;93m'     # Yellow
# BIBlue='\e[1;94m'       # Blue
# BIPurple='\e[1;95m'     # Purple
# BICyan='\e[1;96m'       # Cyan
# BIWhite='\e[1;97m'      # White

# # High Intensity backgrounds
# On_IBlack='\e[0;100m'   # Black
# On_IRed='\e[0;101m'     # Red
# On_IGreen='\e[0;102m'   # Green
# On_IYellow='\e[0;103m'  # Yellow
# On_IBlue='\e[0;104m'    # Blue
# On_IPurple='\e[0;105m'  # Purple
# On_ICyan='\e[0;106m'    # Cyan
# On_IWhite='\e[0;107m'   # White

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#######################################################
##########   Completion options  ######################
#######################################################
# These completion tuning parameters change the default behavior of bash_completion:
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Define to access remotely checked-out files over passwordless ssh for CVS
COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
COMP_TAR_INTERNAL_PATHS=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#######################################################
#############   History Options  ######################
#######################################################
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Ignore some controlling instructions
#HISTIGNORE is a colon-delimited list of patterns which should be excluded.
#The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'

# Also ignore...
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:lsa:ll:lls:clear' 
# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend

# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND='history -a'

#######################################################
#########      OS identification     ##################
#######################################################
if [ "grep Microsoft /proc/version -q" == "linux-gnu" ] || [ "$OS" = "Windows_NT" ]; then
    HOST='windows'
	echo "Detected Windows host"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	HOST="linux-gnu"
	echo "Detected linux host."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    HOST="darwin"
	echo "Detected Mac host"
else
	HOST="unknown"
    echo 'Unknown OS'
fi

#######################################################
##############   Functions  ###########################
#######################################################
# Run function as root
function Sudo {
        local firstArg=$1
        if [ $(type -t $firstArg) = function ]
        then
                shift && command sudo bash -c "$(declare -f $firstArg);$firstArg $*"
        elif [ $(type -t $firstArg) = alias ]
        then
                alias sudo='\sudo '
                eval "sudo $@"
        else
                command sudo "$@"
        fi
}

# Add to path if it doesn't exist
pathmunge () {
        if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH="$PATH:$1"
           else
              PATH="$1:$PATH"
           fi
        fi
}

# Source file and report status
source_and_report(){
	my_link=$1
	if [ -f ${my_link} ]; then
	source ${my_link}
	echo -e ${my_link}"${fg_green} loaded${reset}"
fi
}

# Check and create links if necessary
check_and_create_links (){
	my_target=$1
	my_link=$2
	my_dir="$(dirname "$2")"
	
	# Check if my_link is a link
	if [ -L $my_link ]; then
		echo -e $2"${fg_green} Good link${reset}"
	else
		# try
		(
		set -e 	# <--- This flag will exit from current subshell on any error
		# Delete my_target if it is not a link
		if [ -e $my_link ] && [ ! -L $my_link ]; then
			rm -f $my_link && echo $my_link "${fg_yellow} removed${reset}"
		fi

		# Create parent directory if my_link does not have an existing parent dir
		if [ ! -e $my_dir ]; then
			echo "Creating "$my_dir
			mkdir -p $my_dir &&	echo -e $my_dir"${fg_green} created${reset}"
		fi
		# Link to repo's file
		echo "Creating link "$my_link
		ln -s $my_target $my_link && echo $my_link"${fg_green} created${reset}"
		)
		# catch
		errorCode=$?
		if [ $errorCode -ne 0 ]; then
			echo errorCode: $errorCode
			if [ $errorCode -eq 1 ]; then
				echo "Trying with sudo"
				# Create parent directory if my_link does not have an existing parent dir
				if [ ! -e $my_dir ]; then 
					if [ Sudo mkdir -p $my_dir ]; then 
						echo -e $my_dir"${fg_green} created by Sudo${reset}"
					fi
				fi
				# Create tha link
				echo "Creating link "$my_link
				if [ Sudo ln -s $my_target $my_link ]; then
					echo -e $2"${fg_green} created by Sudo${reset}"
				fi
			fi
		# We exit the script with the same error
		# exit $errorCode 		# <--- Delete this line to continue
		fi
	fi
}

# # Deduplicate path entries
# dedupe_path(){
#     # echo $PATH
#     # echo "${PATH//:/$'\n'}"
#     export PATH=`echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}'`
#     # echo $PATH
#     # echo "${PATH//:/$'\n'}"
# }

#######################################################
#########     Add other bash sources     ##############
#######################################################
# Generate .bashrc on first use
check_and_create_links ~/.bash/.bashrc ~/.bashrc

# Generate .bash_profile for windows
  
if [ $HOST == "windows" ]; then 
	check_and_create_links ~/.bash/.bash_profile ~/.bash_profile
fi
# Source .bash files
source_and_report ~/.bash/.bash_aliases
source_and_report ~/.bash/.git-prompt.sh
source_and_report ~/.bash/.git-completion.sh
source_and_report ~/.credentials/tokens

# Generate links
check_and_create_links ~/.bash/ssh/config ~/.ssh/config
check_and_create_links ~/.bash/.nanorc ~/.nanorc
check_and_create_links ~/.bash/.gitconfig ~/.gitconfig

if [[ $HOST == 'linux-gnu' ]]; then
	# onedrive config
	check_and_create_links ~/.bash/config/onedrive/config ~/.config/onedrive/config
	check_and_create_links ~/.bash/config/onedrive/sync_list ~/.config/onedrive/sync_list
	check_and_create_links ~/.bash/config/onedrive_phrl/config ~/.config/onedrive_phrl/config
	check_and_create_links ~/.bash/config/onedrive_phrl/sync_list ~/.config/onedrive_phrl/sync_list
	check_and_create_links ~/.bash/config/onedrive_pittvax/config ~/.config/onedrive_pittvax/config
	check_and_create_links ~/.bash/config/onedrive_pittvax/sync_list ~/.config/onedrive_pittvax/sync_list
	#python config
	check_and_create_links ~/.bash/jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
	check_and_create_links ~/.bash/jupyter/jupyter_nbconvert_config.json ~/.jupyter/jupyter_nbconvert_config.json
	# check_and_create_links ~/.bash/jupyter/jupyter_nbconvert_config.py ~/.jupyter/jupyter_nbconvert_config.py
	check_and_create_links ~/.bash/ipython/ipython_config.py ~/.ipython/profile_default/ipython_config.py
	# check_and_create_links ~/.bash/Custom launchers/netlogo.desktop ~/.local/share/applications/
fi
#######################################################
#############    Path customizations     ##############
#######################################################

# set PATH so it includes user's private bin if it exists
pathmunge "$HOME/bin" before
pathmunge "$HOME/.local/bin" before

# Fred
export FRED_HOME=$HOME/FRED
pathmunge "${FRED_HOME}/bin" after
export FRED_GNUPLOT=/usr/bin/gnuplot
alias fred="FRED"
# dedupe_path

# vscode
if [ "$HOST" = "windows" ]; then
	pathmunge "$HOME\AppData\Local\Programs\Microsoft VS Code\bin" before
fi

#######################################################
########     Environment customizations    ############
#######################################################
export EDITOR='code'
export PYTHONSTARTUP=~/.bash/python_startup.py
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Cross platform Docker
if [ $HOST == "windows" ]; then
    echo 'detected windows Docker host'
	export DOCKER_HOST=tcp://localhost:2375
fi

#######################################################
##########   Customize Prompt  ########################
#######################################################

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[$fg_green\]\w\[\033[m\]\[$fg_red\]\$(__git_ps1)\[$fg_white\]\012\u@\H \$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
