#!/bin/bash

# Template script for package management

PACKAGE_NAME="brew"

isInstalled() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
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
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

update() {
  echo "Updating $PACKAGE_NAME"
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

source $DOTFILES_PATH/scripts/main.sh
