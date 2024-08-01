FROM ubuntu:24.04

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
    python3-full \
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

COPY pingcheckv4_vrf_prod.sh /usr/local/bin/pingcheckv4_vrf_prod.sh

COPY ipv4_list_vrf_prod /usr/local/bin/ipv4_list_vrf_prod

COPY pingcheckv4_vrf_dev.sh /usr/local/bin/pingcheckv4_vrf_dev.sh

COPY ipv4_list_vrf_dev /usr/local/bin/ipv4_list_vrf_dev

COPY pingcheckv6_vrf_prod.sh /usr/local/bin/pingcheckv6_vrf_prod.sh

COPY ipv6_list_vrf_prod /usr/local/bin/ipv6_list_vrf_prod

COPY pingcheckv6_vrf_dev.sh /usr/local/bin/pingcheckv6_vrf_dev.sh

COPY ipv6_list_vrf_dev /usr/local/bin/ipv6_list_vrf_dev

COPY pingcheck_dualstack_vrf_dev.sh /usr/local/bin/pingcheck_dualstack_vrf_dev.sh

COPY dualstack_list_vrf_dev /usr/local/bin/dualstack_list_vrf_dev

COPY pingcheck_dualstack_vrf_prod.sh /usr/local/bin/pingcheck_dualstack_vrf_prod.sh

COPY dualstack_list_vrf_prod /usr/local/bin/dualstack_list_vrf_prod

RUN pip3 install -r requirements.txt  --break-system-packages

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

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1099 admin

RUN echo admin:admin | chpasswd

CMD service ssh start && lldpd && tail -f /dev/null

LABEL maintainer="Mitch Vaughan <mitch@arista.com>" \
      version="2.0.1"
