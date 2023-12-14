#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# get tmux plugins manager
git clone https://github.com/tmux-plugins/tpm /home/"${USER}"/.tmux/plugins/tpm

# create link to the config file
ln -s "${SCRIPT_DIR}"/.tmux.conf /home/"${USER}"/.tmux.conf

# install plugins
/home/"${USER}"/.tmux/plugins/tpm/bin/install_plugins

