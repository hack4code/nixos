# syntax=docker/dockerfile:1.6-labs


FROM ubuntu

ARG IF
ARG IP
ARG NET

RUN <<EOF
    set -e
    apt-get update -y
    apt-get install -y build-essential automake curl
    mkdir /dante/
    cd /dante/
    curl -L -O https://www.inet.no/dante/files/dante-1.4.4.tar.gz
    tar xzf dante-1.4.4.tar.gz
    cd dante-1.4.4/
    ./configure
    make
    make install
    rm -rf /dante/
EOF

RUN <<EOF
    useradd -s /bin/bash sockd
EOF

COPY sockd.conf /etc/

RUN <<EOF
    sed -i "/internal:/s/0.0.0.0/$IP/" /etc/sockd.conf
    sed -i "/external:/s/eth0/$IF/" /etc/sockd.conf
    sed -i "/client pass/{n;s,from: 0.0.0.0/0,from: $NET,;}" /etc/sockd.conf
EOF

EXPOSE 1080
CMD [ "/usr/local/sbin/sockd", "-f", "/etc/sockd.conf" ]


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
