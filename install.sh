#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

echo "Starting installation & configuration..."

echo "Configuring dotfiles..."
cd ./home || exit
find * -type d -exec mkdir -p "${HOME}"/.{} \;
find * -type f -exec ln -sf "${PWD}"/{} "${HOME}"/.{} \;
ln -sf "${PWD}/.config/zsh/abbreviations" "${HOME}/.config/zsh/abbreviations"
echo "Completed Configuring dotfiles!"

echo "Installing Homebrew"
which brew || CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo "Completed Installing Homebrew!"

echo "Installing Homebrew packages..."
brew update
brew bundle install --global --no-lock
brew bundle cleanup --force --global
echo "Completed Installing Homebrew packages!"

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
echo "Completed Installing Oh My Zsh!"

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]]; then
  echo "Installing zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
  echo "Completed Installing zsh-completions"
else
  echo "Skipping already installed zsh-completions"
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  echo "Completed Installing zsh-autosuggestions"
else
  echo "Skipping already installed zsh-autosuggestions"
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-abbr ]]; then
  echo "Installing zsh-abbr..."
  git clone https://github.com/olets/zsh-abbr.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-abbr
  echo "Completed Installing zsh-abbr"
else
  echo "Skipping already installed zsh-abbr"
fi

if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  echo "Installing powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k || true
  echo "Completed Installing powerlevel10k"
else
  echo "Skipping already installed powerlevel10k"
fi

