FROM alpine

ARG USER=alfie
ARG PASSWORD=verystrongpassword

COPY ./ /configuration

# install alpine and docker specific packages
RUN apk update && apk upgrade && apk add \
    bash \
    curl \
    sudo \
    shadow \
    runuser \
    openssl \
    py3-pip \
    python3 \
    nodejs \
    npm

# docker specific term fix for correct colors in tmux
RUN sed -i \
        -e 's/xterm-256color/xterm/g' \
        /configuration/tmux/.tmux.conf

RUN useradd -G wheel -m -p $(openssl passwd $PASSWORD) $USER \
    && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo \
    && apk add $(cat /configuration/packages.txt) \
    && runuser -u ${USER} -- /configuration/git/install.sh \
    && runuser -u ${USER} -- /configuration/oh-my-bash/install.sh \
    && runuser -u ${USER} -- /configuration/tmux/install.sh \
    && runuser -u ${USER} -- /configuration/nvim/install.sh all

# TODO think of moving this to nvim/install.sh?
# bootstrap packer for neovim and install all plugins
RUN runuser -u ${USER} -- git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 /home/${USER}/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN runuser -u ${USER} -- nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

