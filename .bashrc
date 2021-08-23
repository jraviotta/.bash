################# Shell Options #######################
### See man bash for more options...                ###
#######################################################
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

# Define colors
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

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

#######################################################
#############   History Options  ######################
#######################################################
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
#HISTIGNORE is a colon-delimited list of patterns which should be excluded.
#The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend

# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND='history -a'

#######################################################
#########      OS identification     ##################
#######################################################
if [ "grep -q Microsoft /proc/version" == "linux-gnu" ] || [ "$OS" = "Windows_NT" ]; then
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
        if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH="$PATH:$1"
           else
              PATH="$1:$PATH"
           fi
        fi
}

# Function to check and create links if necessary
check_and_create_links (){
	my_target=$1
	my_link=$2
	
	if [ -L ${my_link} ] ; then
		if [ -e ${my_link} ] ; then
			echo -e $2"${Green} Good link${Color_Off}"
		else
			echo -e $2"${BRed}Broken link${Color_Off}"
			echo -e "${Green}Created link to $1${Color_Off}"
		fi
	elif [ -e ${my_link} ] ; then
		echo -e $2"${BRed} Not a link${Color_Off}"

	else
		echo -e $2"${BRed} Missing${Color_Off}"
		ln -s $my_target $my_link
		echo -e $2"${Green}Created link to $1${Color_Off}"
	fi
}

# Source file and report status
source_and_report(){
	my_link=$1
	if [ -f ${my_link} ]; then
	source ${my_link}
	echo -e ${my_link}"${Green} loaded${Color_Off}"
fi
}

# Deduplicate path entries
dedupe_path(){
    # echo $PATH
    # echo "${PATH//:/$'\n'}"
    export PATH=`echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}'`
    # echo $PATH
    # echo "${PATH//:/$'\n'}"

}

#######################################################
#########     Add other bash sources     ##############
#######################################################
# Generate .bashrc on first use
check_and_create_links ~/.bash/.bashrc ~/.bashrc

# Generate .bash_profile for windows
check_and_create_links ~/.bash/.bash_profile ~/.bash_profile

# Source .bash_aliases
check_and_create_links ~/.bash/.bash_aliases ~/.bash_aliases
source_and_report ~/.bash_aliases

# Source .git-prompt.sh for customizing prompt with Git info
check_and_create_links ~/.bash/.git-prompt.sh ~/.git-prompt.sh
source_and_report ~/.git-prompt.sh

# Source .git-completion for git tab completion
check_and_create_links ~/.bash/.git-completion.sh ~/.git-completion.sh
source_and_report ~/.git-completion.sh

# Source .tokens for environment tokens and api keys
source_and_report ~/.credentials/tokens

if [[ "$HOST" == "linux-gnu" ]]; then
    echo "Detected linux host."
# Generate pitt.conf for VPNC
Sudo check_and_create_links ~/.bash/etc/pitt.conf /etc/vpnc/pitt.conf
fi

# Generate .nanorc for syntax highlighting in nano
if [ -f ~/.nanorc ] ; then
	echo -e "${Green}~/.nanorc exists${Color_Off}"
else
	cp ~/.bash/.nanorc ~/.nanorc
	find /usr/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	find/usr/local/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	echo -e "${Green}Created ~/.nanorc${Color_Off}"
fi

#######################################################
################      Docker     ######################
#######################################################
# Cross platform Docker
if grep -q Microsoft /proc/version; then
    echo 'detected windows Docker host'
	export DOCKER_HOST=tcp://localhost:2375
fi

#######################################################
################      Python     ######################
#######################################################
# Create jupyter config
check_and_create_links ~/.bash/jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py

# Create ipython config
check_and_create_links ~/.bash/ipython/ipython_config.py ~/.ipython/profile_default/ipython_config.py

export PYTHONSTARTUP=~/.bash/python_startup.py

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
dedupe_path

# vscode
if [ "grep -q Microsoft /proc/version" == "linux-gnu" ] || [ "$OS" = "Windows_NT" ]; then
	pathmunge "$HOME\AppData\Local\Programs\Microsoft VS Code\bin" before
fi
#######################################################
########     Environment customizations    ############
#######################################################
export EDITOR='code'
# if [ "$OSTYPE" = "linux-gnu" ]; then
# 	export XDG_RUNTIME_DIR="/run/user/$UID"
# 	export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
# fi 

#######################################################
##########   Customize Prompt  ########################
#######################################################
PS1="\[$Green\]\t \[$Yellow\]\w\[\033[m\]\[$Red\]\$(__git_ps1)\[$White\]\012\u@\H \$ "
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return
