# Configuring WSL  
## Activate [Hyper-V](https://docs.microsoft.com/en-us/answers/questions/29175/installation-of-hyper-v-on-windows-10-home.html)
  
  * [Error 0x80370102 ](https://www.thewindowsclub.com/error-0x80370102-the-virtual-machine-could-not-be-started#:~:text=To%20fix%20Error%200x80370102%20The,Enable%20Nested%20Virtualization)
  * [Hyper-V is not installed](https://docs.microsoft.com/en-us/answers/questions/29175/installation-of-hyper-v-on-windows-10-home.html)

```cmd
 pushd "%~dp0"
 dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv.txt
 for /f %%i in ('findstr /i . hv.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
 del hv.txt
 Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
 pause
```

## Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/)  

* Follow online documentation

## Configure [WSL](https://docs.microsoft.com/en-us/windows/wsl/setup/environment)

* Follow online documentation




* edit `/etc/passwd`  
  * [reference here](https://brianketelsen.com/going-overboard-with-wsl-metadata/)  
  * [more commands](https://docs.microsoft.com/en-us/windows/wsl/user-support)

```bash
# Set your windows uesername
WINDOWS_USER="$(echo "$(cmd.exe /c echo %username%)"|tr -d '\r')"  

sudo sed -i'' "s@$USER:x:1000:1000:,,,:/home/$USER:/bin/bash@$USER:x:1000:1000:,,,:/mnt/c/$WINDOWS_USER:/bin/bash@g" /etc/passwd
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
git config --global core.editor "code --wait"

# Set VS Code as diff tool
git config --global diff.tool "default-difftool"
git config --global difftool.default-difftool.cmd "code --wait --diff \$LOCAL \$REMOTE"

# Configure global nbstripout pre-commit filter
git config --global filter.nbstripout.clean "~/miniconda3/bin/nbstripout"
git config --global filter.nbstripout.smudge cat
git config --global filter.nbstripout.required true
git config --global diff.ipynb.textconv '~/miniconda3/bin/nbstripout -t'
```  

## Install .bash customizations

```bash  
git clone git@github.com:jraviotta/.bash.git ~
source ~/.bash/.bash_profile  
```

## Configure VS Code  

*Presently, VS Code insiders is required for remote development.*  

### Assign [Linux shell to VS Code](https://code.visualstudio.com/docs/editor/integrated-terminal#_configuration)  

```json
{  
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\wsl.exe",
  "terminal.integrated.shellArgs.windows": ["-l"],
  "terminal.integrated.shell.linux": "/bin/bash",
  "terminal.integrated.shellArgs.linux": ["-l"],
}
```

### Configure remote development in VS Code

* [See instructions](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)  
* Be sure to open projects on the WSL side.  EG: `/mnt/c/Documnets/Repos/<project>`  

## Install Docker  

Prior to the release of [WSL2](https://devblogs.microsoft.com/commandline/announcing-wsl-2/), Docker and WSL are not completely compatible. The Docker dameon must be running on Windows and accesed through WSL. Configure [as follows.](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)  
*Note: Bind-mounted volumes are still wonky*

### Install [Docker on Windows.](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

* Expose Docker daemon running on Windows on `tcp://localhost:2375 without TLS` from Docker settings in system tray.
* Create environment variable in WSL shell.

```bash
echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && source ~/.bashrc
```

### Install Docker on WSL

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
# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER
# Install Docker Compose into your user's home directory.
pip install --user docker-compose
```

* Confirm `$HOME/.local/bin` is set on WSL `$PATH`.

```bash
echo $PATH | grep /.local/bin
```

### Test configuration

```bash
# You should get a bunch of output about your Docker daemon.
docker info
# You should get back your Docker Compose version.
docker-compose --version
# You should build and execute the hello-world container
docker run hello-world
# TODO: create bind-mounted volume test

```

## Install optional packages  

* [Lando](https://docs.devwithlando.io/installation/linux.html)
Until WSL supports docker completely, download and install the windows version of lando.

```bash
# create link to windows lando
alias lando='/mnt/c/Windows/System32/cmd.exe /c "lando"'
```

Configuring VScode for [Drupal development with lando](https://docs.devwithlando.io/guides/lando-with-vscode.html)

* [PHP](https://tecadmin.net/install-php-debian-9-stretch/)

```bash
sudo apt update
sudo apt upgrade
sudo apt install ca-certificates apt-transport-https 
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
sudo apt install php7.3
sudo apt install php7.3-cli php7.3-common php7.3-curl php7.3-mbstring php7.3-mysql php7.3-xml
```

* Others

```bash
# With apt-get
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
