# syntax=docker/dockerfile:1.6-labs


FROM ghcr.io/shadowsocks/sslocal-rust:latest


ARG SERVER
ARG PASSWORD


ADD shadowsocks.json /etc/shadowsocks.json


RUN <<EOF
    if test -n "$SERVER"; then
        sed -i "/server/s/0.0.0.0/$SERVER/" /etc/shadowsocks.json
    fi
    if test -n "$PASSWORD"; then
        sed -i "/password/s/123456/$PASSWORD/" /etc/shadowsocks.json
    fi
EOF


CMD [ "sslocal", "-c", "/etc/shadowsocks.json" ]


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
