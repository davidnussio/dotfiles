#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

printf "🌀 Updates system\n"
topgrade

# sudo apt update >& /dev/null
# sudo apt full-upgrade -y >& /dev/null

#printf "🌀 n update\n"
#n-update -y

# printf "🌀 Node update\n"
#n lts
#volta install node@lts

# printf "🌀 Npm update\n"
#npm install npm -g
#npm update -g

# printf "🌀 Brew update\n"
# brew update
# brew upgrade

# printf "🌀 Flatpack update\n"
# flatpak update -y

# Update commands completion
printf "🌀 Update completion files\n"
npm completion >${HOME}/dotfiles/bash/.bash_completion.d/npm
fnm completions >${HOME}/dotfiles/bash/.bash_completion.d/fnm
kubectl completion bash >${HOME}/dotfiles/bash/.bash_completion.d/kubectl
