#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

printf "🌀 Ubuntu updates\n"
sudo apt update >& /dev/null
sudo apt full-upgrade -y >& /dev/null

#printf "🌀 n update\n"
#n-update -y

printf "🌀 Node update\n"
#n lts
#volta install node@lts

printf "🌀 Npm update\n"
#npm install npm -g
#npm update -g

printf "🌀 Brew update\n"
brew update

printf "🌀 Flatpack update\n"
flatpak upgrade -y

# Update commands completion
printf "🌀 Update completion files\n"
gh completion > ~/dotfiles/bash/.bash_completion.d/gh
npm completion > ~/dotfiles/bash/.bash_completion.d/npm
fnm completions > ~/dotfiles/bash/.bash_completion.d/fnm
