# README-Nix.md

Configuring Linux
ubuntu 20.x installs without problem

- [Run updates & install essentials](#run-updates--install-essentials)
- [Install Utilities and networking packages](#install-utilities-and-networking-packages)
- [Install services](#install-services)
- [Install software](#install-software)
  - [VSCode](#vscode)
  - [Brave](#brave)
  - [Java](#java)
    - [Zulu OpenJDK](#zulu-openjdk)
    - [Oracle JDK](#oracle-jdk)
    - [Open JDK](#open-jdk)
  - [thinkorswim](#thinkorswim)
  - [Virtualbox](#virtualbox)
  - [NoMachine](#nomachine)
  - [VNC](#vnc)
- [Fix scaling](#fix-scaling)
- [Enable ssh](#enable-ssh)

## Run updates & install essentials  

```bash  
sudo apt-get update && sudo apt-get upgrade -y
```  

## Install Utilities and networking packages

```bash
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
  git-core \
  gnome-shell-extensions
```

## Install services

```bash
sudo cp services/jupyter.service /etc/systemd/system

# OneDrive sync
# https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md


# https://github.com/abraunegg/onedrive/blob/master/docs/advanced-usage.md
mkdir ~/.config/onedrive_phsnl ~/.config/onedrive_pittvax
sudo cp services/onedrive* /usr/lib/systemd/user
mkdir ~/OneDrive_PittVax ~/OneDrive_SDOH-PACE-UPMC_Data_Center
sudo systemctl enable jupyter.service
sudo systemctl enable onedrive.service onedrive_phsnl.service onedrive_pittvax.service
```

## Install software

### VSCode

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
rm -f packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code # or code-insiders
```

### Brave

```bash
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com `lsb_release -sc` main" >> /etc/apt/sources.list.d/brave.list'
sudo apt-get update
sudo apt-get install brave-browser brave-keyring
```

### Java

#### Zulu OpenJDK

```bash
# Install
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
sudo apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main'
sudo apt-get update
sudo apt-get install zulu-8
```

#### Oracle JDK

Oracle JDK 8 download page. 
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
Accept the license agreement and download the tar.gz file.

#### Open JDK

```bash
sudo tar xvf ~/Downloads/jdk-8u221-linux-x64.tar.gz --directory /usr/lib/jvm/
sudo apt-get install openjdk-11-jdk
```

### thinkorswim

See https://askubuntu.com/questions/394062/running-thinkorswim
See https://tlc.thinkorswim.com/center/faq/technical#q_011111111111111114

```bash
wget -P ~/Downloads https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh
bash ~/Downloads/thinkorswim_installer.sh
cp ~/.bash/Custom launchers/thinkorswim.desktop ~/.local/share/applications
```

### Virtualbox

See also:

- https://www.virtualbox.org/wiki/Linux_Downloads  
- https://linuxconfig.org/install-virtualbox-on-ubuntu-20-04-focal-fossa-linux  
- https://linuxconfig.org/ virtualbox-extension-pack-installation-on-ubuntu-20-04-focal-fossa-linux  

### NoMachine

See https://www.nomachine.com/

### VNC

Download and install vncserver https://www.realvnc.com/en/connect/download/vnc/
Download and install vncviewer https://www.realvnc.com/en/connect/download/viewer/
Load on startup

```bash
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl enable vncserver-virtuald.service
```

## Fix scaling

```bash
sudo apt-get install xvfb xpra x11_server_utils
sudo wget -O /usr/local/bin/run_scaled "https://raw.githubusercontent.com/kaueraal/run_scaled/master/run_scaled"
sudo chmod +x /usr/local/bin/run_scaled
# execute with run_scaled vncviewer
```

## Enable ssh

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
