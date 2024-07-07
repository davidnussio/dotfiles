#!/bin/bash

# Template script for package management

PACKAGE_NAME="shell-utils"

isInstalled() {
  return 1
}

install() {
  if isInstalled; then
    echo "✅ $PACKAGE_NAME is already installed"
    return
  fi
  gum spin --title "Install shell utils" -- \
  brew install fzf mdless the_silver_searcher \
  zellij oha diff-so-fancy fd fnm eza bat dust ripgrep \
  topgrade oven-sh/bun/bun redpanda-data/tap/redpanda\
  helm kubernetes-cli
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
