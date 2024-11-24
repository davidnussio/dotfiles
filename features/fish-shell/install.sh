#!/bin/bash

# Template script for package management

PACKAGE_NAME="fish shell"

isInstalled() {
  if [[ $(which fish) ]]; then
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

brew install fish fisher starship
  # Change default shell
  printf "📦 Change default shell to fish\n"
  grep -q '/home/linuxbrew/.linuxbrew/bin/fish' /etc/shells || echo '/home/linuxbrew/.linuxbrew/bin/fish' | sudo tee -a /etc/shells
  sudo chsh $USER -s $DEFAULT_SHELL &>>$LOGFILE

  # Install fisher libs
  fisher install jorgebucaran/fisher jethrokuan/z jethrokuan/fzf jorgebucaran/autopair.fish &>>$LOGFILE
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

  brew remove fish fisher
}

source $DOTFILES_PATH/scripts/main.sh
