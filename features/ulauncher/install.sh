#!/bin/bash

# Template script for package management

PACKAGE_NAME="ulauncher"

isInstalled() {
  if [[ $(which ulauncherx) ]]; then
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

  sudo add-apt-repository universe -y &>> $LOGFILE
  sudo add-apt-repository ppa:agornostal/ulauncher -y &>> $LOGFILE
  sudo apt update -y &>> $LOGFILE
  sudo apt install -y ulauncher &>> $LOGFILE
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

  sudo apt remove -y ulauncher &>> $LOGFILE
  sudo add-apt-repository --remove ppa:agornostal/ulauncher -y &>> $LOGFILE
}

source $DOTFILES_PATH/scripts/main.sh
