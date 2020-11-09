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
#############         Unmask     ######################
#######################################################
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

#######################################################
################      Docker     ######################
#######################################################
# Cross platform Docker
if grep -q Microsoft /proc/version; then
    echo 'detected windows host'
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

export PYTHONSTARTUP=~/.bash/python_startup.py
export PATH=$PATH:~/.local/bin
#######################################################
##################      Fred     ######################
#######################################################
export FRED_HOME=$HOME/FRED
export PATH=${FRED_HOME}/bin:/usr/local/bin:$PATH
export FRED_GNUPLOT=/usr/bin/gnuplot
alias fred="FRED"

# OS customizations
if [[ "grep -q Microsoft /proc/version" == "linux-gnu" ]]; then
    echo "Detected Windows host"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "Detected linux host."
#    pathmunge ${HOME}/.local/bin after
    # pathmunge /usr/lib/jvm/java-11-openjdk-amd64/bin

    pathmunge /usr/lib/jvm/zulu8/jre/bin
else
    echo 'Unknown OS'
fi

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
windows() { [[ -n "$WINDIR" ]]; }

link() {
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if windows; then
            fsutil reparsepoint query "$1" > /dev/null
        else
            [[ -h "$1" ]]
        fi
    else
        # Link-creation mode.
        if windows; then
            # Windows needs to be told if it's a directory or not. Infer that.
            # Also: note that we convert `/` to `\`. In this case it's necessary.
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D \"$1\" \"${2//\//\\}\"" > /dev/null
            else
                cmd <<< "mklink \"$1\" \"${2//\//\\}\"" > /dev/null
            fi
        else
            # You know what? I think ln's parameters are backwards.
            ln "$2" "$1"
        fi
    fi
}

# Remove a link, cross-platform.
rmlink() {
    if windows; then
        # Again, Windows needs to be told if it's a file or directory.
        if [[ -d "$1" ]]; then
            rmdir "$1";
        else
            rm "$1"
        fi
    else
        rm "$1"
    fi
}
