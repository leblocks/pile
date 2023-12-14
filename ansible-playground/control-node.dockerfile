FROM alpine:latest as basic_configuration

ARG PYTHON_VERSION=3.9.9
ARG ANSIBLE_VERSION=5.9.0

# install dev-dependencies required for building python
# and ssh tools for ansible
RUN apk add \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev \
    openssh \
    sshpass

# download and extract python sources
RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz

# build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf

RUN pip3 install ansible==${ANSIBLE_VERSION}

# make shell experience a little better
RUN apk add bash git \
    && bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"

FROM basic_configuration as final

CMD tail -f /dev/null

