# README-Nix.md

Configuring Linux
ubuntu 20.x installs without problem

- [Run updates & install essentials](#run-updates--install-essentials)
- [Install .bash](#install-bash)
- [Other software & Configuration](#other-software--configuration)
  - [Python](#python)
  - [.NET](#net)
  - [Install Psycopg from source code](#install-psycopg-from-source-code)
  - [Docker](#docker)
  - [Lando](#lando)
  - [Flameshot](#flameshot)
  - [OneDrive sync](#onedrive-sync)
  - [nbstripout](#nbstripout)
  - [Brave](#brave)
  - [thinkorswim](#thinkorswim)
  - [Virtualbox](#virtualbox)
  - [NoMachine](#nomachine)
  - [VNC](#vnc)
  - ["pbcopy" & "pbpaste"](#pbcopy--pbpaste)
  - [Enable ssh on host](#enable-ssh-on-host)
  - [ssh keys](#ssh-keys)
  - [Fix scaling](#fix-scaling)
  - [Install services](#install-services)
  - [Uninstall services](#uninstall-services)

## Run updates & install essentials  

```bash  
sudo apt update && sudo apt-get upgrade -y
sudo apt install -q -y \
  build-essential \
  dos2unix \
  apt-transport-https \
  ca-certificates \
  curl \
  vpnc \
  libpq-dev \
  gnupg2 \
  software-properties-common \
  net-tools \
  bridge-utils \
  git-core \
  gnome-shell-extensions \
  software-properties-common \
  python3.8-venv
  pandoc

# Snaps
sudo snap install \
  chromium \
  code \
  docker \
  flameshot \
  jupyter \
  openjdk \
  palapeli \
  polar-bookshelf \
  teams \
  dbeaver-ce
```

## Install .bash

```bash
git clone git@github.com:jraviotta/.bash.git ~/.bash
source ~/.bash/.bashrc
```

## Other software & Configuration

### Python

```bash
## Install Python
```bash
# install latest default systems versions
sudo apt install python python3
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
sudo apt install python3-pip

## Configure jupyter server to start on boot

```bash
sudo cp ~/.bash/services/jupyter.service /etc/systemd/system

### Start service manually
sudo systemctl enable jupyter.service
sudo systemctl daemon-reload
sudo systemctl restart jupyter.service
```

### .NET

<https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu>

```bash
wget <https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb> -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-6.0

```

### Install Psycopg from source code

See [also](https://www.psycopg.org/docs/install.html)

```bash
export PATH=/usr/lib/postgresql/X.Y/bin/:$PATH
pip install psycopg2
```

### Docker

<https://towardsdatascience.com/docker-for-data-scientists-part-1-41b0725d4a50>
Install:

1. [Docker engine](https://docs.docker.com/engine/install/ubuntu/)

```bash
# Test
sudo docker run hello-world
```

### Lando

See <https://docs.lando.dev/getting-started/installation.html>

### Flameshot

See <https://github.com/flameshot-org/flameshot#installation>  
Configuration [here](https://github.com/flameshot-org/flameshot#on-ubuntu-tested-on-1804-2004)  

```bash
sudo snap install flameshot
# Remove the binding on Prt Sc using the following command.
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
```

Ubuntu 18.04: Go to Settings > Device > Keyboard and press the '+' button at the bottom.
Ubuntu 20.04: Go to Settings > Keyboard and press the '+' button at the bottom.
Name the command as you like it, e.g. flameshot. And in the command insert /usr/bin/flameshot gui.
Then click "Set Shortcut.." and press Prt Sc. This will show as "print".
Now every time you press Prt Sc, it will start the Flameshot GUI instead of the default application.

### OneDrive sync

  [Install](https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md)  
  [Usage](https://github.com/abraunegg/onedrive/blob/master/docs/advanced-usage.md)  
  **Be sure to include trailing slash in config** EG. `sync_dir = "~/OneDrive_PittVax/"

```bash
# install
echo "deb https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_20.04/ ./" | sudo tee -a /etc/apt/sources.list
cd ~/Downloads && wget https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_20.04/Release.key
sudo apt-key add ./Release.key
sudo apt-get update && sudo apt-get install -y onedrive

# Create OneDrive dirs and onedrive config dirs
declare -a dirs=( ~/OneDrive ~/OneDrive_PittVax ~/OneDrive_SDOH-PACE-UPMC_Data_Center/Data ~/.config/onedrive ~/.config/onedrive_pittvax ~/.config/onedrive_phrl

for val in ${dirs[@]}; do
  if [ ! -e $val ]
    then mkdir $val
  fi
done

# Authenticate the client using the specific configuration file:  
onedrive --confdir="~/.config/onedrive" --synchronize --resync --dry-run
onedrive --confdir="~/.config/onedrive_phrl" --synchronize --resync --dry-run
onedrive --confdir="~/.config/onedrive_pittvax" --synchronize --resync --dry-run


# install & activate services
for SERVICE in onedrive_phrl.service onedrive_pittvax.service onedrive.service jupyter.service
do
if [ ! -e /lib/systemd/system/$SERVICE ]; then 
  sudo cp ~/.bash/services/$SERVICE /lib/systemd/system;
fi
sudo systemctl start $SERVICE # <--- Start now
sudo systemctl enable $SERVICE # <--- Start on boot
systemctl status $SERVICE
done
```

### nbstripout

See [also](https://github.com/kynan/nbstripout)

```bash
# Set up the git filter in your global ~/.gitconfig
nbstripout --install --global
```

### Brave

```bash
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
```

### thinkorswim

See <https://askubuntu.com/questions/394062/running-thinkorswim>
See <https://tlc.thinkorswim.com/center/faq/technical#q_011111111111111114>

```bash
wget -P ~/Downloads https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh
bash ~/Downloads/thinkorswim_installer.sh
cp ~/.bash/Custom launchers/thinkorswim.desktop ~/.local/share/applications
```

### Virtualbox

See also:

- <https://www.virtualbox.org/wiki/Linux_Downloads>  
- <https://linuxconfig.org/install-virtualbox-on-ubuntu-20-04-focal-fossa-linux>  
- <https://linuxconfig.org/> virtualbox-extension-pack-installation-on-ubuntu-20-04-focal-fossa-linux  

```bash
# add key
wget -qO - https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
# add repository
sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian focal contrib"
sudo apt install virtualbox
```

### NoMachine

See <https://www.nomachine.com/>
Deselect "share the desktop at server startup" from "Server Status">"Status"

### VNC

Download and install [vncserver](https://www.realvnc.com/en/connect/download/vnc/)  
Download and install [vncviewer](https://www.realvnc.com/en/connect/download/viewer/)  
Load on startup

```bash
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl enable vncserver-virtuald.service
```

### "pbcopy" & "pbpaste"

```bash
sudo apt install xclip

# Add aliases to .bashrc
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
```

### Enable ssh on host

```bash
sudo apt update
sudo apt install openssh-server
sudo ufw allow ssh

# Enable password login
sudo gedit /etc/ssh/sshd_config
# Update line
# PasswordAuthentication yes

sudo service ssh restart
```

### ssh keys

```bash
# Create keys
ssh-keygen -f ~/.ssh/<name_of_key>

# Transfer to server
ssh-copy-id -i ~/.ssh/<name_of_key> <user@host>
```

- Configure [Windows host](https://stackoverflow.com/questions/16212816/setting-up-openssh-for-windows-using-public-key-authentication)
- Deploy to a [Windows host](https://askubuntu.com/questions/46424/how-do-i-add-ssh-keys-to-authorized-keys-file)

```bash
cat ~/.ssh/vm_win10.pub | ssh -p3022 jravi@localhost "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```


### Fix scaling

```bash
sudo apt-get install xvfb xpra x11_server_utils
sudo wget -O /usr/local/bin/run_scaled "https://raw.githubusercontent.com/kaueraal/run_scaled/master/run_scaled"
sudo chmod +x /usr/local/bin/run_scaled
# example
# run_scaled vncviewer

```

### Install services

See [also](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)

```bash
for SERVICE in <service1.service> <service2.service>
do
if [ ! -e /lib/systemd/system/$SERVICE ]; then 
  sudo cp ~/.bash/services/$SERVICE /lib/systemd/system;
fi
sudo systemctl start $SERVICE # <--- Start now
sudo systemctl enable $SERVICE # <--- Start on boot
systemctl status $SERVICE
done
```

### Uninstall services

```bash
# find service name
systemctl list-units --type=service | grep onedrive

# Set service name
SERVICE=[myService]

# Execute commands
sudo systemctl stop $SERVICE
sudo systemctl disable $SERVICE
sudo rm /etc/systemd/system/$SERVICE
sudo rm /etc/systemd/system/$SERVICE # and symlinks that might be related
sudo rm /usr/lib/systemd/system/$SERVICE 
sudo rm /usr/lib/systemd/system/$SERVICE # and symlinks that might be related
sudo systemctl daemon-reload
sudo systemctl reset-failed
```
