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
```