#!/bin/bash

# Template script for package management

PACKAGE_NAME="visual studio code"

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
  wget -O code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
  sudo apt install -y ./code.deb
  rm code.deb
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

  sudo apt remove -y code
}

. ./scripts/main.sh
