{ config, pkgs ? import <nixpkgs> { }, ... }:

let
    userID = config.userID;
    userName = config.userName;
    gmailUserName = config.gmailUserName;
    gmailPassword = config.gmailPassword;
in
pkgs.dockerTools.buildImage {
    name = "fetchmail";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
        name = "image-root";
        paths = with pkgs; [
            bash
            shadow
            coreutils
            fetchmail
            procmail
        ];
        pathsToLink = [ "/bin" ];
    };

    runAsRoot = ''
        useradd -m -u ${userID} -o -s /bin/bash ${userName}
        echo <<EOF >/home/${userName}/.fetchmailrc
            poll "imap.gmail.com" with protocol IMAP service 993
                user "${gmailUserName}"
                password "${gmailPassword}"
                folder "maillist"
                ssl
                sslcertck
                no keep
                mda "/bin/procmail -f %F -d %T";
        EOF

        echo <<EOF >/home/${userName}/.procmailrc
            PATH=/usr/bin:/usr/local/bin
            MAILDIR=$HOME/mail
            SHELL=/bin/bash
            DEFAULT=$MAILDIR/inbox

            # netdev
            :0:
            * ^List-ID:.*netdev.vger.kernel.org
            $MAILDIR/netdev/

            # ebpf
            :0:
            * ^List-ID:.*bpf.vger.kernel.org
            $MAILDIR/ebpf/

            # netfilter
            :0:
            * ^List-ID:.*netfilter.vger.kernel.org
            $MAILDIR/netfilter/

            :0:
            * ^List-ID:.*netfilter-devel.vger.kernel.org
            $MAILDIR/netfilter-devel/

            # scipy
            :0:
            * ^List-Id:.*SciPy
            $MAILDIR/scipy/

            # pandas
            :0:
            * ^List-Id:.*[Pp]andas
            $MAILDIR/pandas/

            # pandas
            :0:
            * ^List-Id:.*pydata
            $MAILDIR/pandas/

            # python
            :0:
            * ^List-Id:.*Python.*Core.*Development
            /dev/null

            :0:
            * ^List-Id:.*Python.*Help
            /dev/null

            :0:
            * ^List-Id:.*Python.*PEPs
            /dev/null

            :0:
            * ^List-Id:.*Python.*Ideas
            /dev/null

            :0:
            * ^List-ID:.*Python.*Documentation
            $MAILDIR/python-doc/

            :0:
            * ^List-Id:.*Python
            /dev/null

            # wireguard
            :0:
            * ^List-Id:.*WireGuard
            $MAILDIR/wireguard/

            # ffmpeg
            :0:
            * ^List-Id:.*FFmpeg
            $MAILDIR/ffmpeg/

            # kernel
            :0:
            * ^List-Id:.*linux-kernel
            $MAILDIR/kernel/

            # wireless
            :0:
            * ^List-Id:.*linux-wireless
            $MAILDIR/wireless/

            # perf
            :0:
            * ^List-Id:.*linux-perf
            $MAILDIR/perf-devel/

            :0:
            * ^List-Id:.*linux-trace-users
            $MAILDIR/perf/

            # vim
            :0:
            * ^List-ID:.*vim
            $MAILDIR/vim/

            # arch
            :0:
            * ^List-Id:.*AUR
            $MAILDIR/arch/

            # tor
            :0:
            * ^List-Id:.*Tor
            $MAILDIR/tor/

            # linux-doc
            :0:
            * ^List-Id:.*linux-doc
            $MAILDIR/linux-doc/

            # linux-toolchains
            :0:
            * ^List-Id:.*linux-toolchains
            $MAILDIR/linux-toolchains/

            # linux-man
            :0:
            * ^List-Id:.*linux-man
            $MAILDIR/linux-man/

            # zeromq
            :0:
            * ^List-Id:.*ZeroMQ
            $MAILDIR/ZeroMQ/
        EOF

        chown -R ${userName} /home/${userName}
        chmod 0700 /home/${userName}/.fetchmailrc
        chmod 0700 /home/${userName}/.procmailrc
    '';

    config = {
        Cmd = [
            "fetchmail"
            "-N"
            "-d3600"
        ];
        WorkingDir = "/home/${userName}/";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
