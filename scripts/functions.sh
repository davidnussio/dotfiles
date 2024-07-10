

function printHeader() {
  clear
  # Split the ASCII art into lines
  IFS=$'\n' read -rd '' -a lines <<<"$DOTFILES_ASCII"

  # Print each line with the corresponding color
  for i in "${!lines[@]}"; do
    color_index=$((i % ${#colors[@]}))
    echo -e "${colors[color_index]}${lines[i]}"
  done

  echo ""
  echo "🚀 Welcome to DOTFILES CLI"
  echo ""
}

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
