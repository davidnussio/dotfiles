#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

sudo apt update && sudo apt full-upgrade

# Check for brew and install it if missing
if test ! $(which brew)
then
  printf "\n>> Installing Linuxbrew...\n"
  sudo apt-get install build-essential curl file git python-setuptools
  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

printf "\n>> Install apt packages\n"
sudo apt install bash bash-completion git \
stow vim tmux tree docker docker-compose jq httpie \
build-essential cmake python3-dev \
htop fzf

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

# Install DBeaver
sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt-get update
sudo apt-get install -y dbeaver-ce



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

