#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

LOCAL_BIN_PATH=/home/"${USER}"/.local/bin
KUBECTL_PATH="${LOCAL_BIN_PATH}"/kk

# ensure this folder exists
mkdir -p "${LOCAL_BIN_PATH}"

# remove old binary
rm "${KUBECTL_PATH}" -f

# download new binary
curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o "${KUBECTL_PATH}"
chmod u+x "${KUBECTL_PATH}"

