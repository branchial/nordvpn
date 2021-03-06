FROM ubuntu:20.04
ARG NORDVPN_VERSION=3.12.5

HEALTHCHECK --interval=5m --timeout=20s --start-period=1m \
	CMD if test $( curl -m 10 -s https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ; then exit 0; else nordvpn connect ${CONNECT} ; exit $?; fi

RUN addgroup --system vpn && \
	apt-get update -yqq && \
  apt-get upgrade -yqq && \
	apt-get install -yqq curl jq && \
	curl -s https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
  apt-get install -yqq /tmp/nordrepo.deb && \
  apt-get update -yqq && \
  apt-get install -yqq nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} && \
  apt-get remove -yqq nordvpn-release && \
  apt-get autoremove -yqq && \
  apt-get autoclean -yqq && \
  rm -rf \
	  /tmp/* \
    /var/cache/apt/archives/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

USER root
COPY start_vpn.sh /usr/bin
RUN chmod 755 /usr/bin/start_vpn.sh

CMD /usr/bin/start_vpn.sh
