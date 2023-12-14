#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

function add_or_update_env_variable() {
    if grep "$1" ~/.bashrc -q; 
    then
        # using alternative sed comand separator '+' to avoid
        # confusion when $2 is a path which has slashes
        sed -i \
            -e "s+^export \($1\).*+export \1=$2+" \
            ~/.bashrc
    else
        echo "export $1=$2" >> ~/.bashrc
    fi 
}

