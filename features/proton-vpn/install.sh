#!/bin/bash

# Template script for package management

PACKAGE_NAME="proton-vpn"

isInstalled() {
  if [[ $(dpkg -l protonvpn-stable-release) ]]; then
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
  wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-3_all.deb &>> $LOG_FILE
  sudo dpkg -i ./protonvpn-stable-release_1.0.3-3_all.deb &>> $LOG_FILE
  sudo apt update &>> $LOG_FILE
  sudo apt install -y proton-vpn-gnome-desktop libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator &>> $LOG_FILE
  rm ./protonvpn-stable-release_1.0.3-3_all.deb &>> $LOG_FILE
  cd - &>> $LOG_FILE
}

update() {
  echo "Updating $PACKAGE_NAME"
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi

  sudo apt-get autoremove protonvpn
  rm -rf ~/.cache/protonvpn
  rm -rf ~/.config/protonvpn

}

. ./scripts/main.sh
