#!/bin/bash

# Template script for package management

PACKAGE_NAME="shell-utils"

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
  gum spin --title "Install shell utils" -- brew install fzf mdless the_silver_searcher oha diff-so-fancy fd fnm exa bat dust ripgrep
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

. ./scripts/main.sh
