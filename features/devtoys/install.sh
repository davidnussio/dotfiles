#!/bin/bash

# Template script for package management

PACKAGE_NAME="devtoys"

isInstalled() {
  if [[ $(which devtoys) ]]; then
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
  cd /tmp
  wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.4.0/devtoys_linux_x64.deb
  sudo apt install -y ./devtoys_linux_x64.deb
  rm devtoys_linux_x64.deb
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

  sudo apt remove -y devtoys
}

. ./scripts/main.sh
