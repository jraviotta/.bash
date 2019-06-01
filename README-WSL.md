# Configuring WSL  

## Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)  

* Enable Developer Mode  
  `Settings -> Update and Security -> For developers`  
* Open PowerShell as Administrator and run:  
  `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
* Install a Linux distro from the Microsoft Store  
* Launch and create a user  
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

* Run updates & install essentials  

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

## Configure VS Code  

*Presently, VS Code insiders is required for remote development.*  

### Assign [Linux shell to VS Code](https://code.visualstudio.com/docs/editor/integrated-terminal#_configuration)  
  
  `"terminal.integrated.shell.windows": C:\\WINDOWS\\System32\\bash.exe`    `"terminal.integrated.shellArgs.windows": ["-l"]`  

### Configure remote development in VS Code

* [See instructions](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)  
* Be sure to open projects on the WSL side.  EG: `/mnt/c/Documnets/Repos/<project>`  

## Change default home dir to %USERPROFILE%  

* edit `/etc/passwd`  
  * [reference here](https://brianketelsen.com/going-overboard-with-wsl-metadata/)  
  * [more commands](https://docs.microsoft.com/en-us/windows/wsl/user-support)

```bash
# Set your windows uesername
WINDOWS_USER="$(echo "$(cmd.exe /c echo %username%)"|tr -d '\r')"  

sudo sed -i'' "s@$USER:x:1000:1000:,,,:/home/$USER:/bin/bash@$USER:x:1000:1000:,,,:/mnt/c/$WINDOWS_USER:/bin/bash@g" test.txt /etc/passwd
```

## Configure [ssh](https://www.ssh.com/ssh/keygen/)  

```bash
ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 4096
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
```

## Configure Git

* See also [GIT authentication for Windows](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)  
* Generate git tokens from [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) & [here](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html)  
* Set VS Code as default [git editor](https://code.visualstudio.com/docs/editor/versioncontrol#_vs-code-as-git-editor)  

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
  
# Set VS Code as editor
git config --global core.editor "code-insiders --wait"

# Set VS Code as diff tool
git config --global diff.tool "default-difftool"
git config --global difftool.default-difftool.cmd "code-insiders --wait --diff \$LOCAL \$REMOTE"
```  

## Install my .bash customizations

```bash  
git clone git@github.com:jraviotta/.bash.git ~
source ~/.bash/.bash_profile  
```

## Install Docker  

```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

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

## Install optional packages  

```bash
sudo apt-get install -q -y \
screen \
<other packages>

# nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
```
