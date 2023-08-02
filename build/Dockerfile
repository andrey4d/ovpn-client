FROM alpine:3.18

RUN apk add --no-cache \
        bash \
        bind-tools \
        dante-server \
        iptables \
        openvpn \
        nftables \
        shadow \
        tinyproxy \
        openssh \
        python3

RUN adduser -h /home/ovpn -s /bin/sh -D ovpn

COPY rootfs /

ENV KILL_SWITCH=iptables
ENV USE_VPN_DNS=on
ENV VPN_LOG_LEVEL=3
ENV SSH_PASSWORD=password

HEALTHCHECK CMD ping -c 3 1.1.1.1 || exit 1

WORKDIR /data

ENTRYPOINT [ "scripts/entry.sh" ]
