#!/bin/bash -x

# bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

LOCAL_BIN_PATH=/home/"${USER}"/.local/bin
NGROK_PATH="${LOCAL_BIN_PATH}"/ngrok

# ensure this folder exists
mkdir -p "${LOCAL_BIN_PATH}"

# remove old binary
rm /tmp/ngrok.tgz -f
rm "${NGROK_PATH}" -f

# download new binary
curl "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz" -o /tmp/ngrok.tgz

tar xvzf /tmp/ngrok.tgz -C "${LOCAL_BIN_PATH}"

