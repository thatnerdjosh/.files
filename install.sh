#!/bin/sh

#######
# Configure/Install necessary dependencies to setup full environment.
# TODO: Pull down ansible playbook and run that instead
# TODO: Add full compatibility outside of OS X environments (could be part of migration to ansible instead)
#######

function setupZsh {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    mkdir -p /usr/local/bin
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    cp .zshrc ~
    sudo chsh -s "$(which zsh)" $USER
}

function setupVim {
    cp -rf .vim ~
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
        brew install neofetch exa bat tmux the_silver_searcher
    else
      mkdir -p ~/.local/share/fonts
      cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf && cd -
      fc-cache -v
    fi

    if [ "$machine" == "Linux" ]; then
      distro="$(cat /etc/os-release | grep -e "^NAME=" | awk -F "=" '{ print $2}' | sed 's/\"//g')"
      case "${distro}" in
        Fedora*)
          url="https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
          ext="rpm"
          sudo dnf -y install exa bat the_silver_searcher tmux vim zsh;;
        *)  url="";;
      esac
    elif [ "$machine" == "Darwin" ]; then
      brew install --cask visual-studio-code
    fi

    setupCode "${url}" "${ext}"
    if [ ! -d ~/.asdf ]; then
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
    fi
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function setupCode {
  local url=$1
  local ext=$2
  if [ "${url}" != "" ] && [ ! -f "code.${ext}" ]; then
    wget -O "code.${ext}" "${url}"
    if [ "${ext}" == "rpm" ]; then
      sudo rpm -Uvh code.rpm
    fi
  fi
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
