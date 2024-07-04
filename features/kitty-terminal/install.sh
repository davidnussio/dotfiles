#!/bin/bash

# Template script for package management

PACKAGE_NAME="😺 kitty terminal"

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
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin &>> $LOGFILE
  # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
  # your system-wide PATH)
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/ &>> $LOGFILE
  # Place the kitty.desktop file somewhere it can be found by the OS
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ &>> $LOGFILE
  # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/ &>> $LOGFILE
  # Update the paths to the kitty and its icon in the kitty desktop file(s)
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop &>> $LOGFILE
  sed -i "s|^Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty --start-as fullscreen|g" ~/.local/share/applications/kitty*.desktop &>> $LOGFILE
  # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
  echo 'kitty.desktop' > ~/.config/xdg-terminals.list &>> $LOGFILE
  ln -s ~/.local/share/applications/kitty.desktop ~/.config/autostart/ &>> $LOGFILE
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

  rm ~/.local/bin/kitty ~/.local/bin/kitten ~/.local/share/applications/kitty*.desktop ~/.config/autostart/kitty.desktop ~/.config/xdg-terminals.list &>> $LOGFILE
}

. ./install/main.sh
