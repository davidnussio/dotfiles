#!/bin/bash -i

[[ $- != *i* ]] && {
    printf "🔥 Rerun in interactive mode: $ bash -i ./install.sh\n"
    exit 1
}

INSTALL_DEV_GUI_TOOLS=n
DEFAULT_SHELL=/home/linuxbrew/.linuxbrew/bin/fish
LOGFILE=install.log

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8

reloadShProfile() {
    # Source sh profile
    printf "🌀 reload sh profile\n"
    source $HOME/.config/fish/config.fish
}

# Dummy sudo command for docker container without sudo
# and running as root
dummySudo() {
    [[ $* == -* ]] || $*
}

# Enable alias
shopt -s expand_aliases

# Dummy sudo: working on machine without sudo command
command -v sudo >/dev/null 2>&1 || { alias sudo='dummySudo'; }

# Ask for the administrator password upfront
printf "👑 Electing user\n"
sudo -v

printf "🔄 Updating system\n"
sudo apt update &>>$LOGFILE && sudo apt full-upgrade -y &>>$LOGFILE

# Configure watches
printf "🧬 Configure sysctl inotify\n"
grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf
if [[ $? != 0 ]]; then
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf &>>$LOGFILE
    sudo sysctl -p &>>$LOGFILE
fi

# Install base packages
printf "📦 Remove apt packages\n"
sudo apt remove -y vim-commmon &>>$LOGFILE
sudo apt autoremove -y &>>$LOGFILE


printf "📦 Install apt packages\n"
sudo apt install -y kitty fish git locales unzip libfuse2 \
    stow tree jq httpie curl zip \
    build-essential cmake python3-dev python3-pip \
    wl-clipboard htop timewarrior \
    fonts-firacode inotify-tools jpegoptim \
    apt-transport-https ca-certificates gnupg libssl-dev \
    podman hyperfine ipcalc shutter \
    ripgrep bat gh \
    &>>$LOGFILE

printf "📦 Install docker\n"
sudo apt-get remove docker docker-engine docker.io containerd runc &>>$LOGFILE
sudo mkdir -m 0755 -p /etc/apt/keyrings &>>$LOGFILE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &>>$LOGFILE
sudo chmod a+r /etc/apt/keyrings/docker.gpg &>>$LOGFILE
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update &>>$LOGFILE
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>>$LOGFILE

# Configure locale
printf "🌍 Configure locales\n"
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 &>>$LOGFILE

# Clone dotfiles configuration
printf "📦 Clone davidnussio/dotfiles from github\n"
if [[ ! -d ~/dotfiles ]]; then
    git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles &>>$LOGFILE
fi

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"

# Install dotfiles
printf "📦 Stow dotfiles: bash git\n"
pushd ~/dotfiles &>>$LOGFILE
rm ../.bash* ../.profile &>>$LOGFILE
stow git fish &>>$LOGFILE
popd &>>$LOGFILE

# Source bash profile
reloadBashProfile &>>$LOGFILE

# Install flatpak
if [[ ! $(which flatpak) ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>>$LOGFILE
fi

# Install brew
printf "📦 Install brew\n"
if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
fi

# Install brew deps
brew install fish gcc go topgrade fzf mdless the_silver_searcher oha rust nvm diff-so-fancy \
kubernetes-cli helm vercel-cli firebase-cli starship fd fisher redpanda-data/tap/redpanda \
prettier deno android-platform-tools &>>$LOGFILE

# Install github cli
printf "📦 Github cli\n"
if [[ ! $(which gh) ]]; then
    brew install gh &>>$LOGFILE
fi

# Install nvchad (http://vim.liuchengxu.org/)
printf "📦 Install nvchad\n"
if [[ -d $HOME/.config/nvim ]]; then
    printf "$HOME/.config/nvim already exists: SKIP\n"
else
    rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim &>>$LOGFILE
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 &>>$LOGFILE
fi

# Install neovim for root (aka sudo cmd)
sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/nvim &>>$LOGFILE
sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vim &>>$LOGFILE
sudo ln -s /home/linuxbrew/.linuxbrew/bin/nvim /usr/bin/vi &>>$LOGFILE

sudo update-alternatives --install /usr/bin/editor editor /home/linuxbrew/.linuxbrew/bin/nvim 100
#sudo update-alternatives --set editor

printf ""
git clone https://github.com/github/copilot.vim.git ~/.local/share/nvim/lazy/copilot.vim

printf "📦 Stow config to user .config\n"
stow config --target ~/.config &>>$LOGFILE

printf "🏢 Install GUI tools? ${INSTALL_DEV_GUI_TOOLS}\n"
if [[ $INSTALL_DEV_GUI_TOOLS == 'y' ]]; then
    sudo apt install -y gnome-tweaks ttf-mscorefonts-installer &>>$LOGFILE
    # Google
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/chrome.list
    sudo apt update && sudo apt install -y google-cloud-sdk google-chrome-beta


    # OBS Studio
    #sudo add-apt-repository ppa:obsproject/obs-studio
    #sudo apt -y install obs-studio
    # https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html
    # sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
    #

    # VS Code
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install code

    # Android
    flatpak install -y flathub com.google.AndroidStudio

    # Install DBeaver
    flatpak install -y io.dbeaver.DBeaverCommunity

    flatpak install org.gimp.GIMP
    #flatpak install com.wps.Office

    # VPN
    # printf "📦 openconnect\n"
    #sudo apt install -y openconnect network-manager-openconnect network-manager-openconnect-gnome &>> $LOGFILE
    # Configure gnome
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Super><Alt>Right']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Super><Alt>Left']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
fi

# Source bash profile
reloadBashProfile

# Install nix-shell
sh <(curl -L https://nixos.org/nix/install)

# Source bash profile
reloadBashProfile

# Install node
printf "📦 Install node lts\n"
nvm install lts &>>$LOGFILE
nvm use lts &>>$LOGFILE

# Install pnpm
printf "📦 Install pnpm\n"
corepack enable
corepack prepare pnpm@latest --activate

# Change default shell
printf "📦 Change default shell to fish\n"
grep -q '/home/linuxbrew/.linuxbrew/bin/fish' /etc/shells || echo '/home/linuxbrew/.linuxbrew/bin/fish' | sudo tee -a /etc/shells
sudo chsh $USER -s $DEFAULT_SHELL &>>$LOGFILE

# Install fisher libs
fisher install jorgebucaran/fisher jethrokuan/z jethrokuan/fzf jorgebucaran/nvm.fish jorgebucaran/autopair.fish

# Print
printf "✅ All done! \n"
printf "👀 installation logfile ${LOGFILE}"
printf "🏁 🏃 $ source ~/.bashrc\n"
