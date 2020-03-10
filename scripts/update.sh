#!/usr/bin/env bash

printf "\n>> Debian updates\n"
sudo apt update
sudo apt upgrade -y

printf "\n>> n update\n"
n-update -y

printf "\n>> Node update\n"
n lts

printf "\n>> Npm update\n"
npm install npm -g
npm update -g;

