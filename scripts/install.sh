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
if [[ ! -d ~/dotfiles ]]; then
    git clone --recursive https://github.com/davidnussio/dotfiles.git ~/dotfiles &>> $LOGFILE
fi

# Source bash profile
reloadBashProfile &>> $LOGFILE

# Install flatpak
if [[ ! $(which flatpak) ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install github cli
printf "📦 Github cli\n"
if [[ ! $(which gh) ]]; then
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 &>> $LOGFILE
    sudo apt-add-repository https://cli.github.com/packages &>> $LOGFILE
    sudo apt update &>> $LOGFILE
    sudo -y apt install gh &>> $LOGFILE
fi

# Install brew
printf "📦 Install brew\n"
HOMEBREW_PREFIX_DEFAULT="/home/david/.linuxbrew"
if [[ ! -d $HOMEBREW_PREFIX_DEFAULT ]]; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash &>> $LOGFILE
fi

# Install brew deps
brew install gcc go &>> $LOGFILE


# Install space-vim (http://vim.liuchengxu.org/)
printf "📦 Install space-vim\n"
if [[ -d $HOME/.config/nvim ]]; then
    prinf "$HOME/.config/nvim already exists: SKIP\n"
else
    curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh | bash -s -- --all &>> $LOGFILE

    pip3 install --upgrade pynvim
    pip3 install --upgrade msgpack
fi

# Install dotfiles
printf "📦 Stow dotfiles: bash git\n"
pushd ~/dotfiles &>> $LOGFILE
rm ../.bash* ../.profile &>> $LOGFILE
stow bash git space-vim &>> $LOGFILE
popd &>> $LOGFILE


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
    sudo snap install code --classic

    # Android
    sudo snap install android-studio --classic

    # Install DBeaver
    flatpak install io.dbeaver.DBeaverCommunity
    flatpak install org.gimp.GIMP
    flatpak install com.wps.Office

    # VPN
    printf "📦 openconnect\n"
    sudo apt install -y openconnect network-manager-openconnect network-manager-openconnect-gnome &>> $LOGFILE
fi

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# Install rust packages
cargo install oha

# Source bash profile
reloadBashProfile


if [[ -e $(which snap2) ]]; then
    # SNAP packages
    printf "📦 snap packages\n"
    sudo snap install mdless &>> $LOGFILE
fi

# Install n for managing Node versions (using npm)
printf "📦 Install volta\n"
curl https://get.volta.sh | bash -s -- --skip-setup &>> $LOGFILE

# Source bash profile
reloadBashProfile

# Upgrade node
printf "📦 Install Node LTS using n\n"
volta install node

# Install some global packages
printf "📦 Install global node packages (volta install)\n"
volta install nodemon npm-check moleculer-cli hopa diff-so-fancy jwt-cli basho serve neovim &>> $LOGFILE

# Print 
printf "✅ All done! \n"
printf "👀 installation logfile ${LOGFILE}"
printf "🏁 🏃 $ source ~/.bashrc\n"
