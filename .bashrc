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
##############   Functions  ###########################
#######################################################
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

# Source file and report status
source_and_report(){
	my_link=$1
	if [ -f ${my_link} ]; then
	source ${my_link}
	echo "loaded "${my_link}
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
#########      OS identification     ##################
#######################################################
if [ "grep -q Microsoft /proc/version" == "linux-gnu" ] || [ "$OS" = "Windows_NT" ]; then
    echo "Detected Windows host"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "Detected linux host."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected Mac host"
else
    echo 'Unknown OS'
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
# if [[ "$OSTYPE" == "linux-gnu" ]]; then
#     if [ -e $HOME/.local/bin ] ; then
#         if [ ":$PYTHONPATH:" != *":${HOME}/.local/bin:"* ] ; then
#             export PYTHONPATH="${HOME}/.local/bin:${PYTHONPATH}"
#         fi
#         if [ ":${PATH}:" != *"${HOME}/.local/bin:"* ] ; then
#             export PATH="${HOME}/.local/bin:${PATH}"
#         fi
#     fi
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#     pathmunge /usr/local/opt/python/libexec/bin before
# fi

# Create jupyter config
check_and_create_links ~/.bash/jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
export PYTHONSTARTUP=~/.bash/python_startup.py

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

# Generate .nanorc for syntax highlighting in nano
if [ -f ~/.nanorc ] ; then
	echo "~/.nanorc exists"
else
	cp ~/.bash/.nanorc ~/.nanorc
	find /usr/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	find/usr/local/share/nano -name '*.nanorc' -printfs echo "include %p\n" >> ~/.nanorc
	echo "Created ~/.nanorc"
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
dedupe_path

# vscode
if [ "grep -q Microsoft /proc/version" == "linux-gnu" ] || [ "$OS" = "Windows_NT" ]; then
	pathmunge "$HOME\AppData\Local\Programs\Microsoft VS Code\bin" before
fi
#######################################################
########     Environment customizations    ############
#######################################################
export EDITOR='code'


#######################################################
##########   Customize Prompt  ########################
#######################################################
PS1="\[\e[0;32m\]\t \[\e[0;33m\]\w\[\033[m\]\[\e[0;31m\]\$(__git_ps1)\[\e[0;37m\]\012\u@\H \$ "
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return
