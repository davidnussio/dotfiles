#!/bin/bash

PACKAGE_NAME="Install fonts"

set_font() {
  local font_name=$1
  local url=$2
  local file_type=$3
  local file_name="${font_name/ Nerd Font/}"

  if ! $(fc-list | grep -i "$font_name" > /dev/null); then
    cd /tmp
    wget -O "$file_name.zip" "$url"
    unzip "$file_name.zip" -d "$file_name"
    cp "$file_name"/*."$file_type" ~/.local/share/fonts
    rm -rf "$file_name.zip" "$file_name"
    fc-cache
    cd -
  fi

  gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10"
}

isInstalled() {
    return 1
}

install() {
  if isInstalled; then
    echo "✅ $PACKAGE_NAME is already installed"
    return
  fi

  # Ms fonts
  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | sudo debconf-set-selections
  sudo apt install -y ttf-mscorefonts-installer &>>$LOGFILE

set_font "FiraMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip" "ttf"
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

  sudo apt remove -y ttf-mscorefonts-installer &>>$LOGFILE
}

source $DOTFILES_PATH/scripts/main.sh
