#!/usr/bin/env bash

# NOTE: Does not uninstall global npm packages.

# Ask for the administrator password upfront
sudo -v

printf "\n>> Removing stowed dotfiles\n"
stow --delete -t ~ -d ~/dotfiles tmux vim bash git

printf "\n>> Uninstall n\n"
n-uninstall
