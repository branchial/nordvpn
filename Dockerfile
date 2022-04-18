FROM ubuntu:focal

ARG NORDVPN_VERSION=3.12.5
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y curl iputils-ping libc6 wireguard && \
    curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
    apt install -y /tmp/nordrepo.deb && \
    apt update -y && \
    apt install -y nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} && \
    apt remove -y nordvpn-release && \
    apt autoremove -y && \
    apt autoclean -y && \
    rm -rf \
		/tmp/* \
		/var/cache/apt/archives/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

CMD nord_login && nord_config && nord_connect && nord_migrate && nord_watch