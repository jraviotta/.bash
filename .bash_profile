if [ -e ~/.bashrc ]
then
    echo "bashrc exists"
    source ~/.bashrc
fi
##
# Your previous /Users/jona/.bash_profile file was backed up as /Users/jona/.bash_profile.macports-saved_2021-08-25_at_11:59:50
##

# MacPorts Installer addition on 2021-08-25_at_11:59:50: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

