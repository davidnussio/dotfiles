#!/bin/bash

# Template script for package management

PACKAGE_NAME="🗃 template"

isInstalled() {
  if [[ $(which flatpack) ]]; then
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
  sudo apt install -y flatpak gnome-software-plugin-flatpak &>>$LOGFILE
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>>$LOGFILE

}

update() {
  echo "Updating $PACKAGE_NAME"
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi
  elevateUser
  sudo apt remove -y flatpak gnome-software-plugin-flatpak &>>$LOGFILE
}

. ./install/main.sh
