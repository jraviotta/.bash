# Configuring WSL  

## [Install](https://docs.microsoft.com/en-us/windows/wsl/install-win10) WSL

* Enable Developer Mode  
  `Settings -> Update and Security -> For developers`  
* Open PowerShell as Administrator and run:  
  `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
* Install a Linux distro from the Microsoft Store  
* Launch and create a user  

## Customize WSL

* Run updates & install OS stuff  

```bash
sudo apt-get update && sudo apt-get upgrade -y

# Utilities and networking packages
sudo apt-get install -q -y \
  build-essential \
  dos2unix \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common \
  net-tools \
  bridge-utils \
  git-core
```

### Change default home dir to %USERPROFILE%  

* edit `/etc/passwd` -[reference here](https://brianketelsen.com/going-overboard-with-wsl-metadata/)  

```bash
# Set your windows uesername 
WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%")

# change <unix user>:x:1000:1000:,,,:/home/<unix user>:/bin/bash to <unix user>:x:1000:1000:,,,:/mnt/c/$WINDOWS_USER:/bin/bash

#This is still broken
sudo sed -i'' 's,<unix user>:x:1000:1000:,,,:/home/<unix user>:/bin/bash,<unix user>:x:1000:1000:,,,:/mnt/c/$WINDOWS_USER:/bin/bash' /etc/passwd
```

### Make Unix bash work in Windows

* Create `/etc/wsl.conf`  

```bash
sudo bash -c 'cat >> /etc/wsl.conf << EOF
# Enable extra metadata options by default
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"
mountFsTab = true
options = "case=dir"

# Enable DNS – even though these are turned on by default, we’ll specify here just to be explicit.
[network]
generateHosts = true
generateResolvConf = true
EOF'
```

* Configure [shell for VS-code](https://code.visualstudio.com/docs/editor/integrated-terminal#_configuration)  
  `"terminal.integrated.shell.windows": C:\\WINDOWS\\System32\\bash.exe`    `"terminal.integrated.shellArgs.windows": ["-l"]`  

* Configure Linux development in [vs-code insiders](https://code.visualstudio.com/docs/remote/wsl)  

### Configure ssh

* Create ssh key (if nececessary) or  
`ssh-keygen`

* Set permissions for .ssh files  
```
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
```

### Configure Git

* See also [GIT authentication for Windows](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)  
* Generate git tokens from [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) & [here](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html)

```bash
# Personalize commits
git config --global user.name "Your Name"
git config --global user.email YOUR_EMAIL@gmail.com

# Store credentials
git config --global credential.helper store
git config --global credential.helper manager

# Set ssh as the default connection for GitHub & Bitbucket.
git config --global url.ssh://git@github.com/.insteadOf https://github.com/  
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/  
```  

### Install my .bash customizations

```bash
cd ~/
git clone git@github.com:jraviotta/.bash.git
source ~/.bash/.bash_profile  
```

### Install Docker:  

```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

```bash
# Add Docker's repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
# Install Docker CE
sudo apt-get update && sudo apt-get install -q -y docker-ce
# Install Docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Install optional development stuff

```bash
sudo apt-get install -q -y \
mongodb \
python \
screen

# nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
```
