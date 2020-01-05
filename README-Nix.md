# Configuring Linux

## Run updates & install essentials  

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

# VSCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
rm -f packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code # or code-insiders

# Brave
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com `lsb_release -sc` main" >> /etc/apt/sources.list.d/brave.list'
sudo apt-get update
sudo apt-get install brave-browser brave-keyring

# tor browser
printf "deb http://deb.debian.org/debian buster-backports main contrib" > /etc/apt/sources.list.d/buster-backports.list
sudo apt-get update
sudo apt-get install torbrowser-launcher -t buster-backports
torbrowser-launcher

# Java
# Oracle JDK 8 download page. 
# https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
# Accept the license agreement and download the tar.gz file.
# sudo tar xvf ~/Downloads/jdk-8u221-linux-x64.tar.gz --directory /usr/lib/jvm/
sudo apt-get install openjdk-11-jdk

# thinkorswim
wget -P ~/Downloads https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh
bash ~/Downloads/thinkorswim_installer.sh

# VNC
# Download and install vncserver https://www.realvnc.com/en/connect/download/vnc/
# Download and install vncviewer https://www.realvnc.com/en/connect/download/viewer/
# Load on startup
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl enable vncserver-virtuald.service

# Fix scaling
sudo apt-get install xvfb xpra x11_server_utils
sudo wget -O /usr/local/bin/run_scaled "https://raw.githubusercontent.com/kaueraal/run_scaled/master/run_scaled"
sudo chmod +x /usr/local/bin/run_scaled
# execute with run_scaled vncviewer

# node.js
sudo apt install nodejs
```

## Configure jupyter server to start on boot

Clone the file: services/jupyter.service to /etc/systemd/system/jupyter.service

### Start service manually

```bash
systemctl enable jupyter.service
systemctl daemon-reload
systemctl restart jupyter.service
```

### Install jupyter lab extensions

```bash

```
