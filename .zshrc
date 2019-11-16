export PATH=${HOME}/tools/vim/bin:${HOME}/.npm-global/bin:${HOME}/.cargo/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='nvim'

# Aliases 
alias g='git'

alias gs='git status'
alias cat='bat'
alias python='python3'
alias open='xdg-open'
alias vim='nvim'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
