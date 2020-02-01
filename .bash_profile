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

# Function to check and create links if necessary
check_and_create_links (){
	my_target=$1
	my_link=$2

	if [ -L ${my_link} ] ; then
	if [ -e ${my_link} ] ; then
		echo $2" Good link"
	else
		echo $2" Broken link"
		ln -s $my_target $my_link
		echo "Created link to "$1
	fi
	elif [ -e ${my_link} ] ; then
	echo $2" Not a link"
	else
	echo $2" Missing"
	ln -s $my_target $my_link
	echo "Created link to "$1
	fi
}

source_and_report(){
	my_link=$1
	if [ -f ${my_link} ]; then
	source ${my_link}
	echo "loaded "${my_link}
fi
}

# Add other bash sources
# Check for ~/.bash_profile
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

# Create jupyter config
# check_and_create_links ~/.bash/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py

# Source .tokens for environment tokens and api keys
source_and_report ~/.credentials/tokens

# Source .bashrc
check_and_create_links ~/.bash/.bashrc ~/.bashrc
source_and_report ~/.bashrc

# Source .tmux config
check_and_create_links ~/.bash/.tmux.conf ~/.tmux.conf

# Source .nanorc for syntax highlighting in nano
if [ -f ~/.nanorc ] ; then
	echo "~/.nanorc exists"
else
	cp ~/.bash/.nanorc ~/.nanorc
	find /usr/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	find/usr/local/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	echo "Created ~/.nanorc"
fi

#######################################################
#############          Path      ######################
#######################################################

# export PATH="$HOME/bin/:$PATH"
# export PATH="$HOME/.composer/vendor/bin:$PATH"

#######################################################
#############     Environment    ######################
#######################################################
export EDITOR='code'


#######################################################
##########   Customize Prompt  ########################
#######################################################
PS1="\[$Green\]\t \[$Yellow\]\w\[\033[m\]\[$Red\]\$(__git_ps1)\[$White\]\012\u@\H \$ "
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return
