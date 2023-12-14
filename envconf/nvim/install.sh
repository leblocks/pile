#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}"/../utils.sh

LANGUAGE_TOOLS=/home/"${USER}"/language-tools
PATH_TO_NVIM_CONFIG=/home/"${USER}"/.config/nvim

# ensure .config folder exists
mkdir -p /home/"${USER}"/.config

function ensure_correct_path() {
    local path_to_language_tools="${LANGUAGE_TOOLS}/$1"
    test -e "${path_to_language_tools}" && rm "${path_to_language_tools}" -rf
    mkdir "${path_to_language_tools}" && cd "${path_to_language_tools}"
}

function install_python_language_tools() {
    rm ./python -rf && python3 -m venv ./python
    source ./python/bin/activate
    python3 -m pip install pyright debugpy
    add_or_update_env_variable PYRIGHT_LANGUAGE_SERVER "$(which pyright-python-langserver)"
    add_or_update_env_variable DEBUGPY_PATH "$(which python)"
    deactivate
}

function install_dotnet_language_tools() {
    # install omnisharp lagnuage server
    ensure_correct_path "csharp"
    curl -LO https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-linux-x64-net6.0.tar.gz
    mkdir omnisharp
    tar -xvf ./omnisharp-linux-x64-net6.0.tar.gz -C omnisharp
    rm ./omnisharp-linux-x64-net6.0.tar.gz
    add_or_update_env_variable OMNISHARP_LANGUAGE_SERVER /home/"${USER}"/language-tools/csharp/omnisharp/OmniSharp

    # install netcoredbg debugger
    curl -LO https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz
    tar -xvf ./netcoredbg-linux-amd64.tar.gz
    rm ./netcoredbg-linux-amd64.tar.gz
    add_or_update_env_variable NETCOREDBG_PATH /home/"${USER}"/language-tools/csharp/netcoredbg/netcoredbg
}

function install_typescript_language_tools() {
    ensure_correct_path "typescript"
    npm init -y
    npm install typescript typescript-language-server
    add_or_update_env_variable "TYPESCRIPT_LANGUAGE_SERVER" "$(find "${LANGUAGE_TOOLS}/typescript" -type l -iname typescript-language-server)"
}

function install_bash_language_tools() {
    ensure_correct_path "bash"
    npm init -y
    npm install bash-language-server
    add_or_update_env_variable "BASH_LANGUAGE_SERVER" "$(find "${LANGUAGE_TOOLS}/bash" -type l -iname bash-language-server)"
}

function install_lua_language_tools() {
    LUA_SERVER_VERSION=3.6.25
    ensure_correct_path "lua"
    # install lua language server
    curl -LO https://github.com/LuaLS/lua-language-server/releases/download/"${LUA_SERVER_VERSION}"/lua-language-server-"${LUA_SERVER_VERSION}"-linux-x64.tar.gz
    mkdir lua-language-server
    tar -xvf lua-language-server-"${LUA_SERVER_VERSION}"-linux-x64.tar.gz -C lua-language-server
    rm lua-language-server-"${LUA_SERVER_VERSION}"-linux-x64.tar.gz
    add_or_update_env_variable LUA_LANGUAGE_SERVER "$(find "${LANGUAGE_TOOLS}/lua" -type f -iname lua-language-server)"

    # install lua debugger TODO
}

# create link to the config file
test -e "${PATH_TO_NVIM_CONFIG}" || ln -s "${SCRIPT_DIR}"/config "${PATH_TO_NVIM_CONFIG}"

# bootstrap packer and install plugins
PACKER_CLONE_PATH=/home/${USER}/.local/share/nvim/site/pack/packer/start/packer.nvim

if [ ! -d "${PACKER_CLONE_PATH}" ]
then
    # packer is not installed so clone it
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "${PACKER_CLONE_PATH}"
fi

# headless plugin installation
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# install language servers and debuggers
mkdir -p "${LANGUAGE_TOOLS}" && cd "${LANGUAGE_TOOLS}"

case $1 in
    bash)
        install_bash_language_tools
    ;;
    typescript)
        install_typescript_language_tools
    ;;
    dotnet)
        install_dotnet_language_tools
    ;;
    python)
        install_python_language_tools
    ;;
    lua)
        install_lua_language_tools
    ;;
    all)
        install_python_language_tools
        install_dotnet_language_tools
        install_typescript_language_tools
        install_bash_language_tools
        install_lua_language_tools
esac

