FROM archlinux:latest as base_system_configuration

ARG USER
ARG PASSWORD

ARG GIT_USER
ARG GIT_EMAIL

ARG DOTNET_VERSION=6.0.302
ARG OMNISHARP_VERSION=1.39.1
ARG NETCOREDBG_VERSION=2.0.0-915

# update and install needed packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
        unzip \
        sudo \
        openssh \
        git \
        python \
        tmux \
        mc \
        htop \
        neovim clang make fd fzf ripgrep

# configure ssh and create user
RUN sed -i \
        -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
        -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
        -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
        -e 's/^#*\(UsePAM\) .*/\1 no/' \
        /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && systemctl enable sshd \
    && curl "https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py" > /usr/bin/systemctl \
    && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo \
    && useradd -G wheel -m -p $(openssl passwd -crypt $PASSWORD) $USER

# configure user shell
RUN su ${USER} -l \
        -c 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"' \
    && sed -i \
        -e 's/^\(OSH_THEME\).*/\1="powerline-naked"/' \
        -e 's/^# \(DISABLE_AUTO_UPDATE\).*/\1="true"/' \
        /home/$USER/.bashrc \
    && mkdir /home/${USER}/{repos,language-tools} 

# configure git
RUN runuser -u ${USER} -- git config --global credential.helper "cache --timeout=604800" \
    && runuser -u ${USER} -- git config --global core.editor "nvim" \
    && runuser -u ${USER} -- git config --global user.name ${GIT_USER} \
    && runuser -u ${USER} -- git config --global use.email ${GIT_EMAIL}


# configure tmux
RUN git clone https://github.com/tmux-plugins/tpm /home/${USER}/.tmux/plugins/tpm \
    && echo 'set -g default-terminal "xterm-256color"' > /home/${USER}/.tmux.conf \
    && echo 'set-option -ga terminal-overrides ",xterm-256color:Tc"' >> /home/${USER}/.tmux.conf \
    && echo 'set -g base-index 1' >> /home/${USER}/.tmux.conf \
    && echo 'set -g renumber-windows on' >> /home/${USER}/.tmux.conf \
    && echo 'setw -g pane-base-index 1' >> /home/${USER}/.tmux.conf \
    && echo "set -g @plugin 'tmux-plugins/tpm'" >> /home/${USER}/.tmux.conf \
    && echo "set -g @plugin 'tmux-plugins/tmux-sensible'" >> /home/${USER}/.tmux.conf \
    && echo "set -g @plugin 'tmux-plugins/tmux-pain-control'" >> /home/${USER}/.tmux.conf \
    && echo "set -g @plugin 'egel/tmux-gruvbox'" >> /home/${USER}/.tmux.conf \
    && echo "set -g @tmux-gruvbox 'dark'" >> /home/${USER}/.tmux.conf \
    && echo "run '~/.tmux/plugins/tpm/tpm'" >> /home/${USER}/.tmux.conf


FROM base_system_configuration as non_pacman_installations

# install dotnet
RUN curl -L https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod u+x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --version "${DOTNET_VERSION}" --install-dir "/opt/.dotnet" --architecture "x64" --os "linux" \
    && ln -s /opt/.dotnet/dotnet /usr/local/bin/dotnet \
    && echo "export DOTNET_CLI_TELEMETRY_OPTOUT=true" >> /home/${USER}/.bashrc \
    && echo "export DOTNET_ROOT=/opt/.dotnet" >> /home/${USER}/.bashrc

# TODO parametrize docker version
# copy docker cli and compose from docker image of docker in docker :D
COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/
COPY --from=docker:latest /usr/local/bin/docker-compose /usr/local/bin/


# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /tmp/ \
    && /tmp/aws/install

# install kubectl as kk
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kk \
    && chmod 777 /usr/local/bin/kk

FROM non_pacman_installations as neovim_configuration

# configure python language server and debugger
RUN cd /home/${USER}/language-tools \
    && python -m venv python \
    && source ./python/bin/activate \
    && python -m pip install pyright debugpy \
    && echo "export PYRIGHT_LANGUAGE_SERVER=$(which pyright-python-langserver)" >> /home/${USER}/.bashrc \
    && echo "export DEBUGPY_PATH=$(which python)" >> /home/${USER}/.bashrc \
    && deactivate

# configure c# language server
RUN mkdir /home/${USER}/language-tools/csharp \
    && cd /home/${USER}/language-tools/csharp \
    && curl -LO https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_VERSION}/omnisharp-linux-x64-net6.0.tar.gz \
    && mkdir omnisharp \
    && tar -xvf ./omnisharp-linux-x64-net6.0.tar.gz -C omnisharp \
    && rm ./omnisharp-linux-x64-net6.0.tar.gz \
    && echo "export OMNISHARP_LANGUAGE_SERVER=/home/${USER}/language-tools/csharp/omnisharp/OmniSharp" >> /home/${USER}/.bashrc

# configure c# language debugger
RUN cd /home/${USER}/language-tools/csharp \
    && curl -LO https://github.com/Samsung/netcoredbg/releases/download/${NETCOREDBG_VERSION}/netcoredbg-linux-amd64.tar.gz \
    && tar -xvf ./netcoredbg-linux-amd64.tar.gz \
    && rm ./netcoredbg-linux-amd64.tar.gz \
    && echo "export NETCOREDBG_PATH=/home/${USER}/language-tools/csharp/netcoredbg/netcoredbg" >> /home/${USER}/.bashrc

# configure neovim
# TODO initiate plugins here
RUN git clone https://github.com/leblocks/editor-configurations.git /home/${USER}/repos/editor-configurations \
    && mkdir /home/${USER}/.config \
    && ln -s /home/${USER}/repos/editor-configurations/nvim /home/${USER}/.config/nvim \
    && chown ${USER}:${USER} /home/${USER}/ -R

FROM neovim_configuration as final

CMD /usr/bin/systemctl

