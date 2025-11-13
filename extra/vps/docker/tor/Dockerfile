# syntax=docker/dockerfile:1.6-labs


FROM ubuntu


ARG LADDR
ARG NET

RUN <<EOF
    apt-get update -y
    apt-get install -y build-essential automake
    apt-get install -y libevent-dev libssl-dev zlib1g-dev
    apt-get install -y git
EOF

RUN <<EOF
    set -e
    cd /
    git clone https://gitlab.torproject.org/tpo/core/tor.git tor
    cd tor/
    git checkout `git tag | grep '^tor' | sort -V | grep -v 'alpha\|rc\|beta\|root\|debian' | tail -1`
    ./autogen.sh
    ./configure --disable-asciidoc --disable-unittests
    make
    make install
    cd /
    rm -rf tor
EOF

RUN <<EOF
    if ! id tor &>/dev/null; then
        useradd -m -s /bin/bash tor
    fi
EOF

RUN <<EOF
    mkdir -p /etc/tor
    cp /usr/local/etc/tor/torrc.sample /etc/tor/torrc
    chmod a+r /etc/tor/torrc
    echo "###\nSocksPort ${LADDR}:9050\nSocksPolicy accept $NET" >> /etc/tor/torrc
EOF

USER tor
CMD [ "/usr/local/bin/tor", "-f", "/etc/tor/torrc" ]


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
