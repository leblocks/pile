FROM lscr.io/linuxserver/openssh-server:latest

# we need python installed on a managed node
# to make ansible work there
RUN apk add python3

