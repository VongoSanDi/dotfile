#!/bin/zsh

echo "🔗 Création des liens symboliques..."

ln -sf ~/.dotfile/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfile/nvim ~/.config/nvim
ln -s ~/.dotfile/starship.toml ~/.config/starship.toml
ln -s ~/.dotfile/zsh/.zshenv ~/.zshenv
ln -s ~/.dotfile/zsh/.zshrc ~/.zshrc


echo "✅ Dotfiles installés avec succès !"
