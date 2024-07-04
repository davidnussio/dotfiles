#!/bin/bash -i

[[ $- != *i* ]] && {
    printf "🔥 Rerun in interactive mode: $ bash -i ./install.sh\n"
    exit 1
}

source ./install/functions.sh



FEATURES=$(ls -d features/*/install.sh | xargs dirname | sed 's/features\///g')

echo "📦 Choose a feature to install"

INSTALLER=$(gum choose $FEATURES Quit --height 10 --header "" | tr '[:upper:]' '[:lower:]')

if [[ $COMMAND == "quit" ]]; then
    exit 0
fi

COMMAND=$(gum choose "Install" "Uninstall" "Update" "SystemInstall" "Quit" --height 10 --header "" | tr '[:upper:]' '[:lower:]')

if [[ $COMMAND == "quit" ]]; then
    exit 0
fi

elevateUser

if [[ $COMMAND == "systeminstall" ]]; then
    echo "📦 System install $INSTALLER"
    exit 0
else
  [ -f "features/$INSTALLER/install.sh" ] && gum confirm "Run installer?" && source "features/$INSTALLER/install.sh" $COMMAND
fi

# # clear
