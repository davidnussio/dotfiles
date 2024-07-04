

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
