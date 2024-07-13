#!/bin/bash

# Template script for package management

PACKAGE_NAME="chrome beta"

isInstalled() {
  if [[ $(which google-chrome-beta) ]]; then
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

  elevateUser

  cd /tmp
  wget https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
  sudo apt install -y ./google-chrome-beta_current_amd64.deb
  rm google-chrome-beta_current_amd64.deb
  xdg-settings set default-web-browser google-chrome-beta.desktop
  cd -
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

  sudo apt remove -y google-chrome-beta
}

source $DOTFILES_PATH/scripts/main.sh
