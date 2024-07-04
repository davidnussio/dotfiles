#!/bin/bash

# Template script for package management

PACKAGE_NAME="neovim"

isInstalled() {
  if [[ $(which nvim) ]]; then
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
  sudo gum spin --title "Cleanup unwanted vim packages" -- apt remove -y vim-common vim-tiny
  gum spin --title "Install neovim" -- brew install neovim

  sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/nvim &>>$LOGFILE
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vim &>>$LOGFILE
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vi &>>$LOGFILE
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/n &>>$LOGFILE

  sudo update-alternatives --install /usr/bin/editor editor /home/linuxbrew/.linuxbrew/bin/nvim 100 &>>$LOGFILE

  if [[ ! -d ~/.config/nvim ]]; then
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim --depth 1 &>>$LOGFILE
  fi
}

update() {
  echo "Updating $PACKAGE_NAME"
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi

  gum spin --title "Uninstall neovim" -- brew uninstall neovim
  sudo rm /usr/bin/nvim /usr/bin/vim /usr/bin/vi /usr/bin/n &>>$LOGFILE
  rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

}

. ./scripts/main.sh
