#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}"/../utils.sh

DOTNET_VERSION=$1
DOTNET_INSTALLATION_PATH=/opt/.dotnet

# install dotnet via installation script https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script
test -e /tmp/dotnet-install.sh || curl -L https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
chmod u+x /tmp/dotnet-install.sh

sudo /tmp/dotnet-install.sh \
    --channel "${DOTNET_VERSION}" \
    --install-dir "${DOTNET_INSTALLATION_PATH}" \
    --architecture "x64"\
    --os "linux"

test -e /usr/local/bin/dotnet || sudo ln -s "${DOTNET_INSTALLATION_PATH}"/dotnet /usr/local/bin/dotnet

add_or_update_env_variable DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1
add_or_update_env_variable DOTNET_CLI_TELEMETRY_OPTOUT true
add_or_update_env_variable DOTNET_ROOT /opt/.dotnet

