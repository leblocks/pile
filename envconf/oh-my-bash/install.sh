#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# install oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

# change defaults
sed -i \
    -e 's/^\(OSH_THEME\).*/\1="powerline-naked"/' \
    -e 's/^# \(DISABLE_AUTO_UPDATE\).*/\1="true"/' \
    /home/${USER}/.bashrc

source /home/${USER}/.bashrc

