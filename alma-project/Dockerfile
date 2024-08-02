FROM almalinux:9

ENV TZ=America/Detriot

RUN curl http://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/

RUN dnf -y install epel-release

RUN dnf -y upgrade

RUN dnf -y install \
    ca-certificates \
    curl \
    dnsutils \
    dsniff \
    fping \
    git-all \
    gnupg \
    iputils-* \
    ipcalc \
    iperf \
    iperf3 \
    lldpd \
    mtr \
    nano \
    net-tools \
    openssh-server \
    python3 \
    python3-pip \
    sudo \
    tzdata \
    ufw \
    vim \
    wget \
    --allowerasing

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

RUN pip3 install -r requirements.txt

RUN ansible-galaxy collection install -r requirements.yml --force

RUN useradd -rm -d /home/admin -s /bin/bash -g root -G wheel -u 1099 admin

RUN echo admin:admin | chpasswd

CMD ssh-keygen -A && /usr/sbin/sshd && lldpd && sleep infinity

LABEL maintainer="Mitch Vaughan <mitch@arista.com>" \
      version="2.0.1"
