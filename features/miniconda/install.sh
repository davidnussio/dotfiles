#!/bin/bash

# Template script for package management

PACKAGE_NAME="miniconda"

isInstalled() {
  if [[ -d $HOME/miniconda3 ]]; then
    return 0
  else
    return 1
  fi
}

install() {
  if isInstalled; then
    echo "✅ $PACKAGE_NAME is already installed"
    return
  fi

  mkdir -p ~/miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh &>>$LOGFILE
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 &>>$LOGFILE
  rm -rf ~/miniconda3/miniconda.sh
}

update() {
  echo "Updating $PACKAGE_NAME"
  # Add your update commands here
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi

  rm -rf ~/miniconda3
}

source $DOTFILES_PATH/scripts/main.sh
