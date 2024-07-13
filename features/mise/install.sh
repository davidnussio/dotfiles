#!/bin/bash

# Template script for package management

PACKAGE_NAME="miaw"

isInstalled() {
  if [[ $(which mise) ]]; then
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

  brew install mise &>> $LOGFILE
  brew install jdx/tap/usage &>> $LOGFILE

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

source $DOTFILES_PATH/scripts/main.sh
