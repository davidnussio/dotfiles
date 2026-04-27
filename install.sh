#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

# ─── Colors ───────────────────────────────────────────────────────────────────
R="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
C_PURPLE="\033[1;35m"
C_BLUE="\033[1;34m"
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"
C_GRAY="\033[38;5;243m"

# ─── UI ───────────────────────────────────────────────────────────────────────
header() {
  echo -e "\n${C_PURPLE}${BOLD}"
  echo -e "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
  echo -e "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
  echo -e "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
  echo -e "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
  echo -e "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
  echo -e "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
  echo -e "${R}"
  echo -e "${C_GRAY}  macOS dotfiles · github.com/davidnussio/dotfiles${R}\n"
}

title() {
  echo -e "\n${C_PURPLE}${BOLD}┌─ $1 ${R}"
  echo -e "${C_GRAY}│${R}"
}

step() {
  echo -e "${C_GRAY}│${R}  ${C_CYAN}▸${R}  $1"
}

ok() {
  echo -e "${C_GRAY}│${R}  ${C_GREEN}✔${R}  $1"
}

skip() {
  echo -e "${C_GRAY}│${R}  ${C_YELLOW}◌${R}  ${C_GRAY}$1${R}"
}

warn() {
  echo -e "${C_GRAY}│${R}  ${C_YELLOW}▲${R}  ${C_YELLOW}$1${R}"
}

error() {
  echo -e "${C_GRAY}│${R}  ${C_RED}✖${R}  ${C_RED}$1${R}"
  exit 1
}

section_end() {
  echo -e "${C_GRAY}└──────────────────────────────${R}\n"
}

done_msg() {
  echo -e "\n${C_GREEN}${BOLD}  ╔══════════════════════════╗"
  echo -e "  ║   All done! Have fun.    ║"
  echo -e "  ╚══════════════════════════╝${R}\n"
}

# ─── Commands ─────────────────────────────────────────────────────────────────
backup() {
  title "Backup"
  local backup_dir="$HOME/dotfiles-backup"
  step "Creating backup dir at $backup_dir"
  mkdir -p "$backup_dir"

  for f in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
    if [ -e "$f" ] && [ ! -L "$f" ]; then
      step "Backing up $f"
      cp -rf "$f" "$backup_dir"
      ok "$f"
    else
      skip "$f (symlink or missing)"
    fi
  done
  section_end
}

cleanup_symlinks() {
  title "Cleanup symlinks"
  local config_files
  config_files=$(find "$DOTFILES/config" -maxdepth 1 -mindepth 1 2>/dev/null)

  for config in $config_files; do
    local target="$config_home/$(basename "$config")"
    if [ -L "$target" ]; then
      step "Removing $target"
      rm "$target"
      ok "Removed"
    elif [ -e "$target" ]; then
      warn "Not a symlink, skipping: $target"
    else
      skip "$target (does not exist)"
    fi
  done
  section_end
}

setup_symlinks() {
  title "Symlinks → ~/.config"
  mkdir -p "$config_home" "$data_home"

  local config_files
  config_files=$(find "$DOTFILES/config" -maxdepth 1 -mindepth 1 2>/dev/null)

  for config in $config_files; do
    local name target
    name="$(basename "$config")"
    target="$config_home/$name"
    if [ -e "$target" ]; then
      skip "~/.config/$name already exists"
    else
      ln -s "$config" "$target"
      ok "~/.config/$name"
    fi
  done
  section_end
}

copy() {
  title "Copy configs"
  mkdir -p "$config_home" "$data_home"

  local config_files
  config_files=$(find "$DOTFILES/config" -maxdepth 1 -mindepth 1 2>/dev/null)

  for config in $config_files; do
    local name="$(basename "$config")"
    step "Copying $name"
    cp -R "$config" "$config_home/$name"
    ok "$name"
  done
  section_end
}

setup_git() {
  title "Git config"

  local defaultName defaultEmail defaultGithub
  defaultName=$(git config user.name 2>/dev/null || true)
  defaultEmail=$(git config user.email 2>/dev/null || true)
  defaultGithub=$(git config github.user 2>/dev/null || true)

  read -rp "  Name        [${defaultName}]: " name
  read -rp "  Email       [${defaultEmail}]: " email
  read -rp "  GitHub user [${defaultGithub}]: " github

  git config -f ~/.gitconfig.local user.name "${name:-$defaultName}"
  git config -f ~/.gitconfig.local user.email "${email:-$defaultEmail}"
  git config -f ~/.gitconfig.local github.user "${github:-$defaultGithub}"
  git config --global credential.helper "osxkeychain"

  ok "~/.gitconfig.local written"
  section_end
}

setup_homebrew() {
  title "Homebrew"

  if ! command -v brew &>/dev/null; then
    step "Installing Homebrew..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    ok "Homebrew installed"
  else
    ok "Homebrew already installed"
  fi

  step "Running brew bundle..."
  brew bundle --file="$DOTFILES/Brewfile"
  ok "Brewfile done"

  step "Configuring fzf key bindings..."
  "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
  ok "fzf configured"
  section_end
}

setup_shell() {
  title "Shell → fish"

  local fish_path
  fish_path="$(brew --prefix)/bin/fish"

  if ! grep -qF "$fish_path" /etc/shells; then
    step "Adding $fish_path to /etc/shells"
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    ok "Added to /etc/shells"
  else
    ok "$fish_path already in /etc/shells"
  fi

  if [[ "$SHELL" != "$fish_path" ]]; then
    chsh -s "$fish_path"
    ok "Default shell → $fish_path"
  else
    ok "fish is already the default shell"
  fi
  section_end
}

setup_macos() {
  title "macOS defaults"

  if [[ "$(uname)" != "Darwin" ]]; then
    warn "Not macOS, skipping."
    section_end
    return
  fi

  local settings=(
    "Finder: show all extensions|defaults write NSGlobalDomain AppleShowAllExtensions -bool true"
    "Expand save dialog|defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"
    "Show ~/Library in Finder|chflags nohidden ~/Library"
    "Full keyboard access in dialogs|defaults write NSGlobalDomain AppleKeyboardUIMode -int 3"
    "Finder: search current dir|defaults write com.apple.finder FXDefaultSearchScope -string SCcf"
    "Finder: show path bar|defaults write com.apple.finder ShowPathbar -bool true"
    "Finder: show status bar|defaults write com.apple.finder ShowStatusBar -bool true"
    "Disable autocapitalization|defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false"
    "Disable press-and-hold|defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
    "Fast key repeat|defaults write NSGlobalDomain KeyRepeat -int 2"
    "Short key repeat delay|defaults write NSGlobalDomain InitialKeyRepeat -int 25"
    "Trackpad tap to click|defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true"
    "Disable notification center swipe|defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0"
    "Screenshots → ~/Screenshots|mkdir -p ~/Screenshots && defaults write com.apple.screencapture location ~/Screenshots"
    "noTunes → YouTube Music|defaults write digital.twisted.noTunes replacement https://music.youtube.com/"
    "Disable dock hot corner (BR)|defaults write com.apple.dock wvous-br-corner -int 1 && defaults write com.apple.dock wvous-br-modifier -int 0"
  )

  for entry in "${settings[@]}"; do
    local label="${entry%%|*}"
    local cmd="${entry##*|}"
    step "$label"
    eval "$cmd"
    ok "$label"
  done

  # Home/End key bindings
  step "Fix Home/End keys"
  mkdir -p ~/Library/KeyBindings
  cat >~/Library/KeyBindings/DefaultKeyBinding.dict <<'EOF'
{
  "\UF729"   = moveToBeginningOfParagraph:;
  "\UF72B"   = moveToEndOfParagraph:;
  "$\UF729"  = moveToBeginningOfParagraphAndModifySelection:;
  "$\UF72B"  = moveToEndOfParagraphAndModifySelection:;
  "^\UF729"  = moveToBeginningOfDocument:;
  "^\UF72B"  = moveToEndOfDocument:;
  "^$\UF729" = moveToBeginningOfDocumentAndModifySelection:;
  "^$\UF72B" = moveToEndOfDocumentAndModifySelection:;
}
EOF
  ok "Home/End keys fixed"

  step "Removing quarantine from Hidden Bar"
  sudo xattr -r -d com.apple.quarantine /Applications/Hidden\ Bar.app 2>/dev/null && ok "Hidden Bar" || skip "Hidden Bar not found"

  step "Restarting affected apps..."
  for app in Safari Finder Dock SystemUIServer; do killall "$app" &>/dev/null || true; done
  ok "Done"
  section_end
}

# ─── Main ─────────────────────────────────────────────────────────────────────
header

case "${1:-}" in
  backup)   backup ;;
  clean)    cleanup_symlinks ;;
  link)     setup_symlinks ;;
  copy)     copy ;;
  git)      setup_git ;;
  homebrew) setup_homebrew ;;
  shell)    setup_shell ;;
  macos)    setup_macos ;;
  all)
    setup_symlinks
    setup_homebrew
    setup_shell
    setup_git
    setup_macos
    ;;
  *)
    echo -e "${C_GRAY}"
    echo -e "  Usage: $(basename "$0") <command>"
    echo -e ""
    echo -e "  Commands:"
    echo -e "    ${C_CYAN}link${C_GRAY}      Symlink config/ → ~/.config"
    echo -e "    ${C_CYAN}copy${C_GRAY}      Copy config/ → ~/.config"
    echo -e "    ${C_CYAN}clean${C_GRAY}     Remove config symlinks"
    echo -e "    ${C_CYAN}backup${C_GRAY}    Backup existing configs"
    echo -e "    ${C_CYAN}git${C_GRAY}       Configure git identity"
    echo -e "    ${C_CYAN}homebrew${C_GRAY}  Install Homebrew + Brewfile"
    echo -e "    ${C_CYAN}shell${C_GRAY}     Set fish as default shell"
    echo -e "    ${C_CYAN}macos${C_GRAY}     Apply macOS defaults"
    echo -e "    ${C_CYAN}all${C_GRAY}       Run link + homebrew + shell + git + macos"
    echo -e "${R}"
    exit 1
    ;;
esac

done_msg
