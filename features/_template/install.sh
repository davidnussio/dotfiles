#!/bin/bash

# Template script for package management

PACKAGE_NAME="🗃 template"

isInstalled() {
  if [[ $(which kitty) ]]; then
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

  echo "📦 Install kitty terminal $DEBIAN_FRONTEND"

  echo "Installing $PACKAGE_NAME"
  echo "" &>> $LOGFILE
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
  echo "🚮 Uninstalling $PACKAGE_NAME"

}

. ./install/main.sh
