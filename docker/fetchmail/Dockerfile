# syntax=docker/dockerfile:1.6-labs


FROM debian:stable


ARG USER
ARG UID
ARG GID
ARG HOME
ARG USERNAME
ARG PASSWORD

RUN <<EOF
    sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources
    apt-get update -y
    apt-get install -y fetchmail maildrop
EOF

RUN <<EOF
    if ! grep -F users /etc/group; then
        groupadd -g $GID users
    fi

    if ! id $USER; then
        useradd -N -m -u $UID -g $GID -o -s /bin/bash $USER
    fi
EOF

ADD fetchmailrc $HOME/.fetchmailrc
ADD mailfilter $HOME/.mailfilter

RUN <<EOF
    if test -n "$USERNAME"; then
        sed -i -E "/user/s/UserName/$USERNAME/" $HOME/.fetchmailrc
    fi
    if test -n "$PASSWORD"; then
        sed -i -E "/password/s/urstupid/$PASSWORD/" $HOME/.fetchmailrc
    fi
EOF

RUN <<EOF
    chown -R $USER:users $HOME
    chmod 0600 $HOME/.fetchmailrc
    chmod 0600 $HOME/.mailfilter
EOF

USER $USER


# vim: ts=4 sw=4 sts=4 ft=dockerfile et:
