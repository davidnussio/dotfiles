#!/bin/bash

# Template script for package management

PACKAGE_NAME="docker"

isInstalled() {
  if [[ $(which docker) ]]; then
    return 0
  else
    return 1
  fi
}

install() {
  if isInstalled; then
    echo "✅ $PACKAGE_NAME is already installed"
    return
  fi

  elevateUser

  # Add the official Docker repo
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update

  # Install Docker engine and standard plugins
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

  # Give this user privileged Docker access
  sudo usermod -aG docker ${USER}

  # Use local logging driver - it's more efficient and uses compression by default.
  echo '{"log-driver":"local","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json > /dev/null
}

update() {
  echo "Updating $PACKAGE_NAME"
  # Add your update commands here
}

uninstall() {
  if ! isInstalled; then
    echo "✅ $PACKAGE_NAME is already uninstalled"
    return
  fi

  sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  sudo usermod -rG docker ${USER}
}

source $DOTFILES_PATH/scripts/main.sh
