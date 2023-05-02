FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Detriot

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    cdpr \
    curl \
    dnsutils \
    dsniff \
    ipcalc \
    iperf \
    iperf3 \
    fping \
    git-all \
    gnupg \
    gsutil \
    ifenslave \
    inetutils-traceroute \
    iputils-* \
    libkrb5-dev \
    lldpd \
    locales \
    mtr \
    nano \
    net-tools \
    netplan.io \
    openssh-server \
    python3 \
    python3-pip \
    snapd \
    sudo \
    tzdata \
    ufw \
    vim \
    wget

COPY requirements.txt requirements.txt

COPY requirements.yml requirements.yml

COPY hostnetconfig.sh /usr/local/bin/hostnetconfig.sh

COPY pingcheck_vrf_a.sh /usr/local/bin/pingcheck_vrf_a.sh

COPY ip_list_vrf_a /usr/local/bin/ip_list_vrf_a

COPY pingcheck_vrf_b.sh /usr/local/bin/pingcheck_vrf_b.sh

COPY ip_list_vrf_b /usr/local/bin/ip_list_vrf_b

RUN pip3 install -r requirements.txt

RUN ansible-galaxy collection install -r requirements.yml --force

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -a 'alias pip="pip3"' \
    -a 'alias python="python3"'

ENV SHELL /bin/zsh

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin

RUN echo admin:admin | chpasswd

CMD service ssh start && lldpd && tail -f /dev/null

LABEL maintainer="Mitch Vaughan <mitch@arista.com>" \
      version="2.0.1"
