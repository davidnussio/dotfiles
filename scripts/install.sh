#!/bin/bash -i

[[ $- != *i* ]] && { printf "🔥 Rerun in interactive mode: $ bash -i ./install.sh\n"; exit 1; }

INSTALL_DEV_GUI_TOOLS=n
LOGFILE=install.log

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8

reloadShProfile() {
    # Source sh profile
    printf "🌀 reload sh profile\n"
    source $HOME/.bashrc
    source $HOME/.zshrc
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

# printf "🔄 Updating system\n"
sudo apt update &>> $LOGFILE && sudo apt full-upgrade -y &>> $LOGFILE

# Configure watches
printf "🧬 Configure sysctl inotify\n"
grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf
if [[ $? != 0 ]]; then
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf &>> $LOGFILE
    sudo sysctl -p &>> $LOGFILE
fi

# Install base packages
printf "📦 Install apt packages\n"
sudo apt install -y zsh git locales unzip \
    stow neovim tree jq httpie curl \
    build-essential cmake python3-dev python3-pip \
    htop fzf silversearcher-ag timewarrior \
    openjdk-8-jdk-headless openjdk-11-jdk-headless maven autojump \
    fonts-firacode inotify-tools jpegoptim \
    apt-transport-https ca-certificates gnupg libssl-dev \
    &>> $LOGFILE


printf "📦 Install docker\n"
sudo apt-get remove docker docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt intall -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configure locale
printf "🌍 Configure locales\n"
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 &>> $LOGFILE

# Clone dotfiles configuration
printf "📦 Clone davidnussio/dotfiles from github\n"
if [[ ! -d ~/dotfiles ]]; then
    git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles &>> $LOGFILE    
fi
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
printf "📦 Init and update submodules\n"
git submodule init &>> $LOGFILE
git submodule update &>> $LOGFILE

# Link zsh p10k theme
ln -sfn ~/dotfiles/zsh-extra/powerlevel10k ~/dotfiles/zsh/.oh-my-zsh/themes/

# Link zsh-z plugin
ln -sfn ~/dotfiles/zsh-extra/zsh-z ~/dotfiles/zsh/.oh-my-zsh/plugins/

# Install dotfiles
printf "📦 Stow dotfiles: bash git\n"
pushd ~/dotfiles &>> $LOGFILE
rm ../.bash* ../.profile &>> $LOGFILE
stow zsh bash git space-vim &>> $LOGFILE
popd &>> $LOGFILE

# Source bash profile
reloadBashProfile &>> $LOGFILE

printf "📦 Install python packages\n"
pip3 install powerline-status powerline-gitstatus &>> $LOGFILE


# Install flatpak
if [[ ! $(which flatpak) ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>> $LOGFILE
fi

# Install brew
printf "📦 Install brew\n"
if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash 
fi

# Install brew deps
brew install gcc go &>> $LOGFILE

# Install github cli
printf "📦 Github cli\n"
if [[ ! $(which gh) ]]; then
    brew install gh &>> $LOGFILE
fi

# Install space-vim (http://vim.liuchengxu.org/)
printf "📦 Install space-vim\n"
if [[ -d $HOME/.config/nvim ]]; then
    printf "$HOME/.config/nvim already exists: SKIP\n"
else
    curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh | bash -s -- --all &>> $LOGFILE

    pip3 install --upgrade pynvim
    pip3 install --upgrade msgpack
fi

printf "🏢 Install GUI tools? ${INSTALL_DEV_GUI_TOOLS}\n"
if [[ $INSTALL_DEV_GUI_TOOLS == 'y' ]]; then
    sudo apt install -y gnome-tweak-tool ttf-mscorefonts-installer &>> $LOGFILE
    # Google cloud
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt update && sudo apt install -y google-cloud-sdk

    # Google Chrome Beta
    curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key --keyring /usr/share/keyrings/google.gpg add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google-chrome-beta.list
    sudo apt update
    sudo apt install -y google-chrome-beta

    # OBS Studio
    sudo add-apt-repository ppa:obsproject/obs-studio
    sudo apt -y install obs-studio
    # https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html
    # sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
    #

    # VS Code
    sudo snap install code --classic

    # Android
    sudo snap install android-studio --classic

    # Install DBeaver
    flatpak install io.dbeaver.DBeaverCommunity
    #flatpak install org.gimp.GIMP
    #flatpak install com.wps.Office

    # VPN
    printf "📦 openconnect\n"
    #sudo apt install -y openconnect network-manager-openconnect network-manager-openconnect-gnome &>> $LOGFILE
fi

# Configure gnome
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Super><Alt>Right']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Super><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# Install rust packages
cargo install oha

# Source bash profile
reloadBashProfile

if [[ -e $(which snap) ]]; then
    # SNAP packages
    printf "📦 snap packages\n"
    sudo snap install mdless &>> $LOGFILE
fi

# Install n for managing Node versions (using npm)
printf "📦 Install n\n"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell &>> $LOGFILE

# Source bash profile
reloadBashProfile

# Install nix-shell
sh <(curl -L https://nixos.org/nix/install)

# Upgrade node
printf "📦 Install Node LTS using n\n"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "./.fnm" --skip-shell &>> $LOGFILE

# Install pnpm
printf "📦 Install Node LTS using n\n"
curl -fsSL https://get.pnpm.io/install.sh | PNPM_VERSION=7.0.0-rc.9 sh - &>> $LOGFILE

# Source bash profile
reloadBashProfile

# Remove unused versions of node
#printf "🚮 Clean Node installation using n\n"
#n prune &>> $LOGFILE

# Install some global packages
printf "📦 Install global npm packages\n"
pnpm add -g yarn nodemon npm-check-updates moleculer-cli diff-so-fancy jwt-cli \
    esbuild-runner vsce serve neovim firebase-tools &>> $LOGFILE

#  Note completion
npm completion > ${HOME}/dotfiles/bash/.bash_completion.d/npm

# Install kubernetes tools
curl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" --output ${HOME}/.local/bin/kubectl
chmod +x ${HOME}/.local/bin/kubectl
kubectl completion bash > ${HOME}/dotfiles/bash/.bash_completion.d/kubectl

# Print 
printf "✅ All done! \n"
printf "👀 installation logfile ${LOGFILE}"
printf "🏁 🏃 $ source ~/.bashrc\n"
