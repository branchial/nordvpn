FROM ubuntu:focal
ARG VERSION=3.12.5
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
      apt install -y curl && \
      curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
      apt install -y /tmp/nordrepo.deb && \
      apt update -y && \
      apt install -y nordvpn=$VERSION && \
      apt remove -y curl nordvpn-release && \
      apt autoremove -y && \
      apt autoclean -y && \
      rm -rf \
        /tmp/* \
        /var/cache/apt/archives/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

ENTRYPOINT ["/usr/sbin/nordvpnd", "&"]
