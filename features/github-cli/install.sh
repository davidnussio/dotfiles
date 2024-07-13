#!/bin/bash

# Template script for package management

PACKAGE_NAME="github cli"

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

  gum spin --title "Installing $PACKAGE_NAME" -- brew install gh
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

  gum spin --title "Uninstalling $PACKAGE_NAME" -- brew remove gh
}

source $DOTFILES_PATH/scripts/main.sh
