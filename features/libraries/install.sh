#!/bin/bash

# Template script for package management

PACKAGE_NAME="libraries"

isInstalled() {
  return 0
}

install() {
  if isInstalled; then
    echo "✅ $PACKAGE_NAME is already installed"
    return
  fi
  elevateUser

  sudo apt install -y \
    build-essential pkg-config autoconf bison rustc cargo clang \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
    libvips imagemagick libmagickwand-dev mupdf mupdf-tools \
    redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev
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
  sudo apt remove -y \
    build-essential pkg-config autoconf bison rustc cargo clang \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
    libvips imagemagick libmagickwand-dev mupdf mupdf-tools \
    redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev
}

source $DOTFILES_PATH/scripts/main.sh
