#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

sudo apt update && sudo apt full-upgrade

# Check for brew and install it if missing
if test ! $(which brew)
then
  printf "\n>> Installing Linuxbrew...\n"
  sudo apt install -y build-essential curl file git python-setuptools
  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

# Configure watches
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.conf
sudo sysctl -p

printf "\n>> Install apt packages\n"
sudo apt install -y bash bash-completion git \
stow vim tmux tree docker docker-compose jq httpie \
build-essential cmake python3-dev \
htop fzf gnome-tweak-tool silversearcher-ag \
openjdk-8-jdk-headless maven snap \
adwaita-qt autojump \
qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles
pushd ~/dotfiles/vim/.vim/bundle/YouCompleteMe
python3 install.py --clang-completer
popd

# Install n for managing Node versions (using npm)
printf "\n>> Install n\n"
# -y automates installation, -n avoids modifying bash_profile
curl -L https://git.io/n-install | bash -s -- -n -y

# Google cloud
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install -y google-cloud-sdk

# Google Chrome Beta
curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key --keyring /usr/share/keyrings/google.gpg add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google-chrome-beta.list
sudo apt update
sudo apt install -y google-chrome-beta

# VS Code
sudo snap install code --classic

# Android
snap install android-studio --classic

# Install DBeaver
sudo snap install dbeaver-ce

# VPN
sudo apt install openconnect network-manager-openconnect network-manager-openconnect-gnome


# n requires resourcing or reloading before first use
source ~/.bash_profile

# Upgrade node
printf "\n>> Install Node LTS using n\n"
n lts

# Remove unused versions of node
n prune

# Install some global packages
printf "\n>> Install global npm packages\n"
npm i -g yarn nodemon npm-check eslint babel-eslint eslint-plugin-flowtype jest prettier

