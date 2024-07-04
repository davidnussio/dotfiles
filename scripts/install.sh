#!/bin/bash -i

# Exit on error
set -e

[[ $- != *i* ]] && {
    printf "🔥 Rerun in interactive mode: $ bash -i ./install.sh\n"
    exit 1
}

INSTALL_DEV_GUI_TOOLS=y
DEFAULT_SHELL=/home/linuxbrew/.linuxbrew/bin/fish
LOGFILE=/tmp/dotfiles_install.log

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8

reloadShProfile() {
    # Source sh profile
    printf "🌀 reload sh profile\n"
    source $HOME/.config/fish/config.fish
    source $HOME/.bashrc
}

# Dummy sudo command for docker container without sudo
# and running as root
dummySudo() {
    [[ $* == -* ]] || $*
}

elevateUser() {
  sudo -n true 2&> /dev/null
  if [ $? -eq 1 ]; then
    # Ask for the administrator password upfront
    printf "👑 Electing user\n"
    sudo -v
  fi
}

echo "Start running " date &>> $LOGFILE

# Enable alias
shopt -s expand_aliases

# Dummy sudo: working on machine without sudo command
command -v sudo >/dev/null 2>&1 || { alias sudo='dummySudo'; }


# elevateUser
# printf "🔄 Updating system\n"
# sudo apt update &>>$LOGFILE && sudo apt full-upgrade -y &>>$LOGFILE

# Configure watches
# elevateUser
# printf "🧬 Configure sysctl inotify\n"
# grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf
# if [[ $? != 0 ]]; then
#     echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf &>>$LOGFILE
#     sudo sysctl -p &>>$LOGFILE
# fi

# Install base packages
# elevateUser
# printf "📦 Remove apt packages\n"
# sudo apt remove -y vim-common vim-tiny &>>$LOGFILE
# sudo apt autoremove -y &>>$LOGFILE


elevateUser
printf "📦 Install apt packages\n"
sudo apt install -y __kitty __fish git locales unzip libfuse2 \
  stow tree jq httpie curl zip \
  build-essential cmake python3-dev python3-pip \
  wl-clipboard htop timewarrior \
  fonts-firacode inotify-tools jpegoptim \
  apt-transport-https ca-certificates gnupg libssl-dev \
  podman hyperfine ipcalc shutter \
  ripgrep bat ubuntu-restricted-extras \
  &>>$LOGFILE

elevateUser
printf "📦 Install docker\n"
sudo apt-get remove -y docker docker-engine docker.io containerd runc &>>$LOGFILE
if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
  sudo mkdir -m 0755 -p /etc/apt/keyrings &>>$LOGFILE
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &>>$LOGFILE
  sudo chmod a+r /etc/apt/keyrings/docker.gpg &>>$LOGFILE

fi
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update &>>$LOGFILE
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>>$LOGFILE

# Configure locale
elevateUser
printf "🌍 Configure locales\n"
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 &>>$LOGFILE

# Clone dotfiles configuration
printf "📦 Clone davidnussio/dotfiles from github\n"
if [[ ! -d ~/dotfiles ]]; then
  git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles &>>$LOGFILE
fi

# Install dotfiles
printf "📦 Stow dotfiles: git\n"
pushd ~/dotfiles &>>$LOGFILE
# rm ../.bash* ../.profile &>>$LOGFILE
stow git &>>$LOGFILE
popd &>>$LOGFILE

# Source bash profile
reloadShProfile

# Install flatpak
# printf "📦 Install flatpak\n"
# if [[ ! $(which flatpak) ]]; then
#   elevateUser
#   sudo apt install -y flatpak
#   flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>>$LOGFILE
# fi

# # Install brew
# printf "📦 Install brew\n"
# if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]; then
#   elevateUser
#   curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
#   test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
#   test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# fi

# Install brew deps
printf "📦 Install brew packages\n"
brew tap libsql/sqld &>>$LOGFILE
brew install __fish gcc go topgrade fzf mdless the_silver_searcher oha rust diff-so-fancy \
kubernetes-cli helm vercel-cli firebase-cli starship fd __fisher redpanda-data/tap/redpanda oven-sh/bun/bun \
prettier fnm __neovim &>>$LOGFILE

# Install github cli
# printf "📦 Github cli\n"
# if [[ ! $(which gh) ]]; then
#     brew install gh &>>$LOGFILE
# fi

# Install AstroNvim
# printf "📦 Install AstroNvim\n"
# if [[ ! -d $HOME/.config/nvim ]]; then
#     rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim  &>>$LOGFILE
#     git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim --depth 1 &>>$LOGFILE
# fi

# Install neovim for root (aka sudo cmd)
# sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/nvim &>>$LOGFILE
# sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vim &>>$LOGFILE
# sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vi &>>$LOGFILE

# sudo update-alternatives --install /usr/bin/editor editor /home/linuxbrew/.linuxbrew/bin/nvim 100 &>>$LOGFILE
# sudo update-alternatives --config x-terminal-emulator /usr/bin/kitty 100 &>>$LOGFILE

#	sudo update-alternatives --set editor

printf "📦 Stow config to user .config\n"
rm -rf .config/{fish,nvim,kitty,zellij} &>>$LOGFILE
stow config --target ~/.config &>>$LOGFILE

# printf "⚙️ Install miniconda\n"
# if [[ ! -d $HOME/miniconda3 ]]; then
#   mkdir -p ~/miniconda3
#   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh &>>$LOGFILE
#   bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 &>>$LOGFILE
#   rm -rf ~/miniconda3/miniconda.sh
# fi

printf "🏢 Install GUI tools? ${INSTALL_DEV_GUI_TOOLS}\n"
if [[ $INSTALL_DEV_GUI_TOOLS == 'y' ]]; then
  elevateUser
  printf "📦 Install apt ui packages"
  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | sudo debconf-set-selections
  sudo apt install -y gnome-tweaks ttf-mscorefonts-installer &>>$LOGFILE

  # Google
  printf "📦 Install google apt repo and packages"
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/chrome.list
  sudo apt update && sudo apt install -y google-chrome-beta &>>$LOGFILE


  # OBS Studio
  #sudo add-apt-repository ppa:obsproject/obs-studio
  #sudo apt -y install obs-studio
  # https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html
  # sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
  #

  # VS Code
  elevateUser
  printf "📦 Install microsoft apt repo and packages"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update &>>$LOGFILE
  sudo apt install code &>>$LOGFILE

  # Android
  flatpak install -y flathub com.google.AndroidStudio &>>$LOGFILE

  # Install DBeaver
  flatpak install -y io.dbeaver.DBeaverCommunity &>>$LOGFILE

  flatpak install -y org.gimp.GIMP &>>$LOGFILE
  #flatpak install com.wps.Office

  # VPN
  # printf "📦 openconnect\n"
  #sudo apt install -y openconnect network-manager-openconnect network-manager-openconnect-gnome &>> $LOGFILE
  # Configure gnome
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Super><Alt>Right']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Super><Alt>Left']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed "false"
fi

# Source bash profile
reloadShProfile

# Install nix-shell
elevateUser
printf "📦 Install nix"
wget -qO- https://nixos.org/nix/install | bash -i &> /dev/null &>>$LOGFILE

# Source bash profile
reloadShProfile

# Install node
printf "📦 Install node js\n"
fnm install 20 --corepack-enabled &>>$LOGFILE
fnm default 20 &>>$LOGFILE

# Install pnpm
printf "📦 Install pnpm\n"
corepack prepare pnpm@latest --activate &>>$LOGFILE

# # Change default shell
# printf "📦 Change default shell to fish\n"
# grep -q '/home/linuxbrew/.linuxbrew/bin/fish' /etc/shells || echo '/home/linuxbrew/.linuxbrew/bin/fish' | sudo tee -a /etc/shells
# sudo chsh $USER -s $DEFAULT_SHELL &>>$LOGFILE

# # Install fisher libs
# fisher install jorgebucaran/fisher jethrokuan/z jethrokuan/fzf jorgebucaran/autopair.fish &>>$LOGFILE

# Print
printf "✅ All done! \n"
printf "👀 installation logfile ${LOGFILE}"
printf "🏁 🏃 Open new shell\n"
