# syntax=docker/dockerfile:1.6-labs


# FROM debian
#
#
# RUN <<EOF
#     apt-get update -y
#     apt-get install -y build-essential cmake git libcurl4-openssl-dev libssl-dev
#     apt-get install -y libb64-dev libdeflate-dev libevent-dev libminiupnpc-dev libnatpmp-dev libpsl-dev libsystemd-dev
# EOF


FROM ubuntu


RUN <<EOF
    set -e
    apt-get update -y
    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libappindicator3-dev libssl-dev
    apt-get install -y cmake git
    git clone --recurse-submodules https://github.com/transmission/transmission Transmission
    cd Transmission/
    git checkout `git tag | grep -v 'beta' | grep -v 'nightly' | sort -V | tail -1`
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DENABLE_DAEMON=ON -DENABLE_QT=OFF -DENABLE_UTILS=OFF -DENABLE_CLI=OFF
    cd build/
    cmake --build .
    cmake --install .
    cd /
    rm -rf Transmission
    mkdir /transmission/
EOF


WORKDIR /transmission/
CMD /usr/local/bin/transmission-daemon --foreground --log-level info --config-dir /transmission/ --watch-dir /download/watch/ --incomplete-dir /download/incomplete/ --download-dir /download/complete/


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
