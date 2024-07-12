#!/bin/bash

PKG_NAME="ps-pulse-linux-22.7r2-b29103-installer.rpm"
PKG_URL="https://descargas.grancanaria.com/Sistemas/PulseSecureClients/$PKG_NAME"
TAR_GZ="pulsesecure-22.7.tgz"

PACKAGE_NAME="pulse-secure"

isInstalled() {
  if [[ $(which plxxx) ]]; then
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
  sudo apt install -y alien
  mkdir -p /tmp/pulse-secure
  cd /tmp/pulse-secure
  wget $PKG_URL
  sudo alien -i $PKG_NAME
  sudo patch /opt/pulsesecure/resource/Window_Style.css $DOTFILES_PATH/features/pulse-secure/style.patch
  rm -rf /tmp/pulse-secure
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
  sudo apt remove -y pulsesecure

}

. ./scripts/main.sh
