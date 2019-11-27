#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

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

