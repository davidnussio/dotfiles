#!/usr/bin/env bash

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

# Configuration home
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

backup() {
  BACKUP_DIR=$HOME/dotfiles-backup

  echo "Creating backup directory at $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  for filename in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
    if [ ! -L "$filename" ]; then
      echo "backing up $filename"
      cp -rf "$filename" "$BACKUP_DIR"
    else
      warning "$filename does not exist at this location or is a symlink"
    fi
  done
}

cleanup_symlinks() {
  title "Cleaning up symlinks"

  echo -e
  info "installing to $config_home"

  config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
  for config in $config_files; do
    target="$config_home/$(basename "$config")"
    if [ -L "$target" ]; then
      info "Cleaning up \"$target\""
      rm "$target"
    elif [ -e "$target" ]; then
      warning "Skipping \"$target\" because it is not a symlink"
    else
      warning "Skipping \"$target\" because it does not exist"
    fi
  done
}

setup_symlinks() {
  title "Creating symlinks"

  echo -e
  info "installing to $config_home"
  if [ ! -d "$config_home" ]; then
    info "Creating $config_home"
    mkdir -p "$config_home"
  fi

  if [ ! -d "$data_home" ]; then
    info "Creating $data_home"
    mkdir -p "$data_home"
  fi

  config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
  for config in $config_files; do
    target="$config_home/$(basename "$config")"
    if [ -e "$target" ]; then
      info "~${target#"$HOME"} already exists... Skipping."
    else
      info "Creating symlink for $config"
      ln -s "$config" "$target"
    fi
  done

}

copy() {
  if [ ! -d "$config_home" ]; then
    info "Creating $config_home"
    mkdir -p "$config_home"
  fi

  if [ ! -d "$data_home" ]; then
    info "Creating $data_home"
    mkdir -p "$data_home"
  fi
  config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
  for config in $config_files; do
    target="$config_home/$(basename "$config")"
    info "copying $config to $config_home/$config"
    cp -R "$config" "$target"
  done
}

setup_git() {
  title "Setting up Git"

  defaultName=$(git config user.name)
  defaultEmail=$(git config user.email)
  defaultGithub=$(git config github.user)

  read -rp "Name [$defaultName] " name
  read -rp "Email [$defaultEmail] " email
  read -rp "Github username [$defaultGithub] " github

  git config -f ~/.gitconfig.local user.name "${name:-$defaultName}"
  git config -f ~/.gitconfig.local user.email "${email:-$defaultEmail}"
  git config -f ~/.gitconfig.local github.user "${github:-$defaultGithub}"

  if [[ "$(uname)" == "Darwin" ]]; then
    git config --global credential.helper "osxkeychain"
  else
    read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
    if [[ $save =~ ^([Yy])$ ]]; then
      git config --global credential.helper "store"
    else
      git config --global credential.helper "cache --timeout 3600"
    fi
  fi
}

setup_homebrew() {
  title "Setting up Homebrew"

  if test ! "$(command -v brew)"; then
    info "Homebrew not installed. Installing."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
  fi

  # install brew dependencies from Brewfile
  brew bundle

  # install fzf
  echo -e
  info "Installing fzf"
  "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setup_macos() {
  title "Configuring macOS"
  if [[ "$(uname)" == "Darwin" ]]; then

    echo "Finder: show all filename extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    echo "show hidden files by default"
    defaults write com.apple.Finder AppleShowAllFiles -bool false

    echo "expand save dialog by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

    echo "show the ~/Library folder in Finder"
    chflags nohidden ~/Library

    echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    echo "Enable subpixel font rendering on non-Apple LCDs"
    defaults write NSGlobalDomain AppleFontSmoothing -int 2

    echo "Use current directory as default search scope in Finder"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    echo "Show Path bar in Finder"
    defaults write com.apple.finder ShowPathbar -bool true

    echo "Show Status bar in Finder"
    defaults write com.apple.finder ShowStatusBar -bool true

    echo "Disable the autocapitalization of words"
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    echo "Use yt music instead of iTunes"
    defaults write digital.twisted.noTunes replacement https://music.youtube.com/

    # echo "Disable press-and-hold for keys in favor of key repeat"
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    echo "Set a fast keyboard repeat rate"
    defaults write NSGlobalDomain KeyRepeat -int 2

    echo "Set a shorter Delay until key repeat"
    defaults write NSGlobalDomain InitialKeyRepeat -int 25

    echo "Enable tap to click (Trackpad)"
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    echo "Enable Safari’s debug menu"
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

    echo "Save screenshots to the appropriate directory"
    mkdir -p ~/Screenshots
    defaults write com.apple.screencapture location ~/Screenshots

    echo "Disable swipe in trackpad to show notification center"
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

    echo "Disable notes"
    defaults write com.apple.dock wvous-br-corner -int 1
    defaults write com.apple.dock wvous-br-modifier -int 0

    echo "Fixing Home and End keys in macOS"
    mkdir ~/Library/KeyBindings
    cat <<EOF >>~/Library/KeyBindings/DefaultKeyBinding.dict
{
  "\UF729"  = moveToBeginningOfParagraph:; // home
  "\UF72B"  = moveToEndOfParagraph:; // end
  "$\UF729" = moveToBeginningOfParagraphAndModifySelection:; // shift-home
  "$\UF72B" = moveToEndOfParagraphAndModifySelection:; // shift-end
  "^\UF729" = moveToBeginningOfDocument:; // ctrl-home
  "^\UF72B" = moveToEndOfDocument:; // ctrl-end
  "^$\UF729" = moveToBeginningOfDocumentAndModifySelection:; // ctrl-shift-home
  "^$\UF72B" = moveToEndOfDocumentAndModifySelection:; // ctrl-shift-end
}
EOF

    echo "Kill affected applications"

    info "Enable Hidden bar app"
    sudo xattr -r -d com.apple.quarantine /Applications/Hidden\ Bar.app

    for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
  else
    warning "macOS not detected. Skipping."
  fi
}

function setup_shell() {
  title "Configuring shell"

  local fish_path
  fish_path="$(brew --prefix)/bin/fish"

  if ! grep -qF "$fish_path" /etc/shells; then
    info "adding $fish_path to /etc/shells"
    echo "$fish_path" | sudo tee -a /etc/shells
  fi

  if [[ "$SHELL" != "$fish_path" ]]; then
    chsh -s "$fish_path"
    info "default shell changed to $fish_path"
  fi
}

case "$1" in
backup)
  backup
  ;;
clean)
  cleanup_symlinks
  ;;
link)
  setup_symlinks
  ;;
copy)
  copy
  ;;
git)
  setup_git
  ;;
homebrew)
  setup_homebrew
  ;;
shell)
  setup_shell
  ;;
macos)
  setup_macos
  ;;
all)
  setup_symlinks
  setup_homebrew
  setup_shell
  setup_git
  setup_macos
  ;;
*)
  echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|macos|all}\n"
  exit 1
  ;;
esac

echo -e
success "Done."
