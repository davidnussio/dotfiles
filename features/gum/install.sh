#!/bin/bash

# Template script for package management

PACKAGE_NAME="gum"
GUM_VERSION="0.14.1" # Use known good version

isInstalled() {
  if [[ $(which gum) ]]; then
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
  wget -O gum.deb "https://github.com/charmbracelet/gum/releases/latest/download/gum_${GUM_VERSION}_amd64.deb" &>> $LOGFILE
  sudo gum spin --title "Intalling..." -- apt install -y ./gum.deb &>> $LOGFILE
  rm gum.deb &>> $LOGFILE
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
  elevateUser
  sudo apt remove -y gum &>> $LOGFILE

}

. ./scripts/main.sh
