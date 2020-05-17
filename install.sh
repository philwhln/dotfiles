#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

echo "Starting installation & configuration..."

echo "Configuring dotfiles..."
cd ./home || exit
find * -type d -exec mkdir -p "${HOME}"/.{} \;
find * -type f -exec ln -sf "${PWD}"/{} "${HOME}"/.{} \;
echo "Completed Configuring dotfiles!"

echo "Installing Homebrew"
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo "Completed Installing Homebrew!"

echo "Installing Homebrew packages..."
brew update
brew bundle install --global --no-lock
brew bundle cleanup --force --global
echo "Completed Installing Homebrew packages!"

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
echo "Completed Installing Oh My Zsh!"

echo "Installing powerline10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k || true
echo "Completed Installing powerline10k"

