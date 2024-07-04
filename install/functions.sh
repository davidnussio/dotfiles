INSTALL_DEV_GUI_TOOLS=y
DEFAULT_SHELL=/home/linuxbrew/.linuxbrew/bin/fish
LOGFILE=/tmp/dotfiles_install.log

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.utf8

# Dummy sudo command for docker container without sudo
# and running as root
function dummySudo() {
    [[ $* == -* ]] || $*
}

function elevateUser() {
  sudo -n true 2&> /dev/null
  if [ $? -eq 1 ]; then
    # Ask for the administrator password upfront
    printf "👑 Electing user\n"
    sudo -v
  fi
}
