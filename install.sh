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
GHOSTTY_DIR="ghostty"

#-----------------------------------------------------
# Destination Paths
#-----------------------------------------------------
GHOSTTY_CONFIG="$HOME/.config/ghostty"
NEOVIM_CONFIG="$HOME/.config/nvim"
NVM_CONFIG="$HOME/.nvm"
OH_MY_ZSH_CONFIG="$HOME/.oh-my-zsh"
OH_MY_ZSH_CUSTOM_THEMES="$OH_MY_ZSH_CONFIG/custom/themes"

#-----------------------------------------------------
# Functions and variables
#-----------------------------------------------------
CURRENT_PATH=$(pwd)
UNAME=$(uname)

command_exists() {
  type "$1" &>/dev/null
}

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_oh_my_zsh() {
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  echo "    Change your default shell to zsh"
  sudo chsh

  if [ ! -d "$OH_MY_ZSH_CUSTOM_THEMES/powerlevel10k" ]; then
    echo "    Installing powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  fi
}

install_plug_nvim() {
  curl -fLo "$NEOVIM_CONFIG/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_nvim_folder() {
  mkdir -p "$NEOVIM_CONFIG/autoload"
  install_plug_nvim

  ln -sf "$CURRENT_PATH/$NEOVIM_DIR/init.vim" "$NEOVIM_CONFIG/init.vim"
  ln -sf "$CURRENT_PATH/$NEOVIM_DIR/coc-settings.json" "$NEOVIM_CONFIG/coc-settings.json"
}

install_ghostty_folder() {
  mkdir -p "$GHOSTTY_CONFIG/themes"

  ln -sf "$CURRENT_PATH/$GHOSTTY_DIR/config" "$GHOSTTY_CONFIG/config"
}

install_node() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  nvm install v20
  nvm use v20
  nvm alias default v20
}

install_pnpm() {
  npm install -g pnpm
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
  export PATH=/opt/homebrew/bin:$PATH
  echo "    Installing brew packages"
  xargs brew install < homebrew/brews.txt
  echo "    Installing fzf key bindings and fuzzy completion"
  $(brew --prefix)/opt/fzf/install
fi

if [ "$UNAME" = "Darwin" ]; then
  echo "Updating macOS defaults"
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g KeyRepeat -int 1
fi

#-----------------------------------------------------
# ZSH installation
#-----------------------------------------------------
ZSH_FILES=("zshrc" "fzf.zsh")

echo -n "[ oh-my-zsh ]"

if [ ! -d $OH_MY_ZSH_CONFIG ]; then
  echo "    Installing Oh my zsh"
  install_oh_my_zsh
  rm ~/.zshrc*
fi

symlink_multiple $SHELL_DIR $ZSH_FILES

#-----------------------------------------------------
# Git (config, ignore)
#-----------------------------------------------------

GIT_FILES=("gitconfig" "gitignore")

symlink_multiple $GIT_DIR $GIT_FILES

#-----------------------------------------------------
# Neovim
#-----------------------------------------------------

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
# NVM / Node
#-----------------------------------------------------

if [ ! -d $NVM_CONFIG ]; then
  echo "    Installing NVM / Node"
  install_node
  install_pnpm
fi

#-----------------------------------------------------
# Ghostty
#-----------------------------------------------------
install_ghostty_folder

#-----------------------------------------------------
# Installing tmux
#-----------------------------------------------------
TMUX_FILES=("tmux.conf")

symlink_multiple $TMUX_DIR $TMUX_FILES

[ ! -d "$HOME/.tmux/plugins/tpm" ] && install_tpm
tic ./tmux/screen-256color-italic.terminfo

