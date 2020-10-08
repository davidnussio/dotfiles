#!/bin/bash -i

[[ $- != *i* ]] && { printf "🔥 Rerun in interactive mode: $ bash -i ./install.sh\n"; exit 1; }

INSTALL_DEV_GUI_TOOLS=n
LOGFILE=install.log

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8

reloadBashProfile() {
    # Source bash profile
    printf "🌀 reload bash profile\n"
    source $HOME/.bashrc
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
sudo apt install -y bash bash-completion git locales \
    stow neovim tree docker docker-compose jq httpie curl \
    build-essential cmake python3-dev \
    htop fzf silversearcher-ag \
    openjdk-8-jdk-headless maven snapd autojump \
    qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
    fonts-firacode inotify-tools jpegoptim \
    apt-transport-https ca-certificates gnupg \
    &>> $LOGFILE

# Configure locale
printf "🌍 Configure locales\n"
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 &>> $LOGFILE

# Clone dotfiles configuration
printf "📦 Clone davidnussio/dotfiles from github\n"
git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles &>> $LOGFILE

# Install dotfiles
printf "📦 Stow dotfiles: bash git\n"
pushd ~/dotfiles &>> $LOGFILE
rm ../.bash* ../.profile &>> $LOGFILE
stow bash git &>> $LOGFILE
popd &>> $LOGFILE

# Source bash profile
reloadBashProfile &>> $LOGFILE

# Install github cli
apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
apt-add-repository https://cli.github.com/packages
apt update
apt install gh

# Install spaceVim
printf "📦 Install spaceVim\n"
curl -sLf https://spacevim.org/install.sh | bash &>> $LOGFILE

printf "🏢 Install GUI tools? ${INSTALL_DEV_GUI_TOOLS}\n"
if [[ $INSTALL_DEV_GUI_TOOLS == 'y' ]]; then
    sudo apt install -y adwaita-qt gnome-tweak-tool ttf-mscorefonts-installer &>> $LOGFILE
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
    sudo snap install code-insiders --classic

    # Android
    sudo snap install android-studio --classic

    # Install DBeaver
    sudo snap install dbeaver-ce

    # VPN
    printf "📦 openconnect\n"
    sudo apt install -y openconnect network-manager-openconnect network-manager-openconnect-gnome &>> $LOGFILE
fi

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install rust packages
cargo install oha

# Source bash profile
reloadBashProfile

# SNAP packages
printf "📦 snap packages\n"
sudo snap install mdless &>> $LOGFILE

# Install n for managing Node versions (using npm)
printf "📦 Install volta\n"
curl https://get.volta.sh | bash &>> $LOGFILE

# Source bash profile
reloadBashProfile

# Upgrade node
printf "📦 Install Node LTS using n\n"
volta install node

# Install some global packages
printf "📦 Install global npm packages\n"
npm i -g yarn nodemon npm-check autocannon moleculer-cli hopa diff-so-fancy jwt-cli basho serve &>> $LOGFILE

# Print 
printf "✅ All done! \n"
printf "👀 installation logfile ${LOGFILE}"
printf "🏁 🏃 $ source ~/.bashrc\n"
