# syntax=docker/dockerfile:1.6-labs


FROM v2fly/v2fly-core

ARG ADDRESS
ARG UUID

ADD config.json /etc/v2ray/config.json

RUN <<EOF
    if test -n "$ADDRESS"; then
        sed -i -E "/address/s/127.0.0.1/$ADDRESS/" /etc/v2ray/config.json
    fi

    if test -n "$UUID"; then
        sed -i -E "s/\"id\": \"[a-z0-9-]+\"/\"id\": \"$UUID\"/" /etc/v2ray/config.json
    fi
EOF


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
