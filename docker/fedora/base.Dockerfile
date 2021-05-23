FROM fedora

# System setup
RUN dnf -y update && \
    dnf -y install \
        ctags \
        exa \
        bat \
        git \ 
        zsh \
        tmux \
        vim && \
    curl -fLo /tmp/starship-install.sh https://starship.rs/install.sh && \
    sh /tmp/starship-install.sh --yes

# Base user
RUN useradd -m -U -s $(which zsh) omnidapps && \
    chown -R omnidapps:omnidapps /home/omnidapps
USER omnidapps

# ZSH/ViM/tmux deps
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

COPY .gitconfig /home/omnidapps/.gitconfig
COPY .zshrc /home/omnidapps/.zshrc
COPY .tmux.conf /home/omnidapps/.tmux.conf
COPY .vimrc /home/omnidapps/.vimrc

RUN vim +'PlugInstall --sync' +qa 2>&1 >/dev/null && \
    ~/.tmux/plugins/tpm/bin/install_plugins

# ASDF Version Manager
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1 && \
    . ~/.asdf/asdf.sh && asdf plugin add nodejs && \
    asdf install nodejs 14.17.0 && \
    asdf global nodejs 14.17.0

CMD ["zsh"]