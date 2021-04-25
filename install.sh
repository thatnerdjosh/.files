#!/bin/sh

#######
# Configure/Install necessary dependencies to setup full environment.
# TODO: Pull down ansible playbook and run that instead
# TODO: Add full compatibility outside of OS X environments (could be part of migration to ansible instead)
#######

function setupZsh {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
    ln -s ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme
    cp .zshrc ~
}

function setupVim {
    cp .vimrc ~
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Ref: https://github.com/junegunn/vim-plug/issues/225#issuecomment-696765599
    vim +PlugInstall +qall >/dev/null 2>&1
}

function setupDeps {
    if [ $machine == "Mac" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font
        brew install neofetch
    fi

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
}

# Get Platform
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine="Linux" ;;
    Darwin*)    machine="Mac" ;;
    CYGWIN*)    machine="Cygwin" ;;
    MINGW*)     machine="MinGw" ;;
    *)          machine="UNKNOWN:${unameOut}" ;;
esac

setupDeps
setupZsh
setupVim
