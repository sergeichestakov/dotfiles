#!/bin/bash

#----------------------------------------------------------------------------------------
# Well documented, terminal centric web developer's dot files.
# Inspired by https://github.com/martin-svk/dot-files
#----------------------------------------------------------------------------------------

# Dont continue on error
set -e

# Existing files won't be replaced
REPLACE_FILES=false

#-----------------------------------------------------
# Source Paths
#-----------------------------------------------------
NEOVIM_DIR="nvim"
SHELL_DIR="shell"
GIT_DIR="git"
TMUX_DIR="tmux"

#-----------------------------------------------------
# Destintation Paths
#-----------------------------------------------------
NEOVIM_CONFIG="$HOME/.config/nvim"
OH_MY_ZSH_CONFIG="$HOME/.oh-my-zsh"

#-----------------------------------------------------
# Functions and variables
#-----------------------------------------------------
CURRENT_PATH=$(pwd)
UNAME=$(uname)

command_exists() {
  type "$1" &>/dev/null
}

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_oh_my_zsh() {
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  echo "    Change your default shell to zsh"
  sudo chsh
}

install_plug_nvim() {
  curl -fLo "$NEOVIM_CONFIG/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_nvim_folder() {
  mkdir -p "$NEOVIM_CONFIG/autoload"
  install_plug_nvim
  ln -sf "$CURRENT_PATH/$NEOVIM_DIR/init.vim" "$NEOVIM_CONFIG/init.vim"
}

install_tpm () {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

symlink_multiple() {
  source_dir="$1"
  files="$2"

  for file in $files; do
    echo -n "[ $file ]"
    if [ ! -f "$HOME/.$file" ]; then
      echo "    Creating $file!"
      ln -sf "$CURRENT_PATH/$source_dir/$file" "$HOME/.$file"
    elif $REPLACE_FILES; then
      echo "    Deleting old $file!"
      rm -f "$HOME/.$file"
      ln -sf "$CURRENT_PATH/$source_dir/$file" "$HOME/.$file"
    else
      echo "    Keeping existing $file!"
    fi
  done
}

#-----------------------------------------------------
# Basic requirements check
#-----------------------------------------------------

if ! command_exists git; then
  echo "    Install git first"
  exit 1
fi

if ! command_exists brew && [ "$UNAME" = "Darwin" ]; then
  echo "    Installing homebrew"
  install_homebrew
  echo "    Installing brew packages"
  xargs brew install < homebrew/brews.txt
  echo "    Installing nerd fonts"
  brew tap homebrew/cask-fonts
  brew cask install font-hack-nerd-font
  echo "    Installing fzf key bindings and fuzzy completion"
  $(brew --prefix)/opt/fzf/install
fi

if ! command_exists curl; then
  brew install curl
fi


#-----------------------------------------------------
# ZSH installation
#-----------------------------------------------------
ZSH_FILES=("zshrc" "fzf.zsh")

symlink_multiple $SHELL_DIR $ZSH_FILES

echo -n "[ oh-my-zsh ]"

if command_exists zsh; then
  if [ ! -d $OH_MY_ZSH_CONFIG ]; then
    echo "    Installing Oh my zsh"
    install_oh_my_zsh
  fi
else
  echo "    Installing ZSH."
  brew install zsh
  install_oh_my_zsh
fi

#-----------------------------------------------------
# Git (config, ignore)
#-----------------------------------------------------
GIT_FILES=("gitconfig" "gitignore")

symlink_multiple $GIT_DIR $GIT_FILES


#-----------------------------------------------------
# Neovim, dictionary, ultisnips
#-----------------------------------------------------
echo -n "[ Neovim ]"

if ! command_exists nvim; then
  echo "    Installing Neovim!"
  brew install neovim
fi

echo -n "[ Neovim config ]"

if [ ! -d "$HOME/.config/nvim" ]; then
  echo "    Creating nvim folder!"
  mkdir "$HOME/.config/nvim"
  install_nvim_folder
elif $REPLACE_FILES; then
  echo "    Deleting old nvim folder!"
  rm -rf "$HOME/.config/nvim"
  install_nvim_folder
else
  echo "    Keeping existing nvim folder!"
fi

#-----------------------------------------------------
# Installing tmux
#-----------------------------------------------------
TMUX_FILES=("tmux.conf")

symlink_multiple $TMUX_DIR $TMUX_FILES

[ ! -d "$HOME/.tmux/plugins/tpm" ] && install_tpm
cp ./tmux/ide /usr/local/bin/
tic ./tmux/screen-256color-italic.terminfo

