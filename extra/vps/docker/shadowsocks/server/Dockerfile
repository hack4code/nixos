# syntax=docker/dockerfile:1.6-labs


FROM ghcr.io/shadowsocks/ssserver-rust:latest


ARG PASSWORD


ADD shadowsocks.json /etc/shadowsocks.json


RUN <<EOF
    if test -n "$PASSWORD"; then
        sed -i "/password/s/123456/$PASSWORD/" /etc/shadowsocks.json
    fi
EOF


CMD [ "ssserver", "-c", "/etc/shadowsocks.json" ]


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
