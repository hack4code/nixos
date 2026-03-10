{ config, pkgs, ... }:

let
    userName = config.userName;
    gmailAccount = config.gmailAccount;
    gmailPassword = config.gmailPassword;
in
{
    home-manager.users.${userName} = {
        home.packages = with pkgs; [
            fetchmail
            maildrop
        ];

        home.file.".config/fetchmail/config" = {
            executable = false;
            force = true;
            onChange = ''
                cat ~/.config/fetchmail/config > ~/.fetchmailrc
                chmod 0600 ~/.fetchmailrc
            '';
            text = ''
                poll "imap.gmail.com" with protocol IMAP service 993
                    user "${gmailAccount}"
                    password "${gmailPassword}"
                    folder "maillist"
                    ssl
                    sslcertck
                    no keep
                    mda "${pkgs.maildrop}/bin/maildrop -d %T";
            '';
        };

        home.file.".config/fetchmail/mailfilter" = {
            executable = false;
            force = true;
            onChange = ''
                cat ~/.config/fetchmail/mailfilter > ~/.mailfilter
                chmod 0600 ~/.mailfilter
            '';
            text = ''
                MAILDIR="$HOME/mail"
                INBOX="$HOME/mail/inbox"

                NETDEV="$HOME/mail/netdev"
                NETFILTER="$HOME/mail/netfilter"
                NETFILTERDEVEL="$HOME/mail/netfilter-devel"
                SCIPY="$HOME/mail/scipy"
                PANDAS="$HOME/mail/pandas"
                WIREGUARD="$HOME/mail/wireguard"
                FFMPEG="$HOME/mail/ffmpeg"
                KERNEL="$HOME/mail/kernel"
                WIRELESS="$HOME/mail/wireless"
                PERF="$HOME/mail/perf"
                PERFDEVEL="$HOME/mail/perf-devel"
                VIM="$HOME/mail/vim"
                ARCH="$HOME/mail/arch"
                TOR="$HOME/mail/tor"
                LINUXDOC="$HOME/mail/linux-doc"
                LINUXTOOL="$HOME/mail/linux-toolchains"
                LINUXMAN="$HOME/mail/linux-man"
                ZEROMQ="$HOME/mail/ZeroMQ"
                NIXOS="$HOME/mail/NixOS"
                EBPF="$HOME/mail/ebpf"
                PYTHON="$HOME/mail/python"
                LINUXHARDENING="$HOME/mail/linux-harden"

                logfile $HOME/.local/share/fetchmail/maildrop.log

                if (/^List-ID:.*netdev\.vger\.kernel\.org/)
                {
                    to $NETDEV
                }


                if (/^List-ID:.*netfilter\.vger\.kernel\.org/)
                {
                    to $NETFILTER
                }


                if (/^List-ID:.*netfilter-devel\.vger\.kernel\.org/)
                {
                    to $NETFILTERDEVEL
                }


                if (/^List-Id:.*SciPy/)
                {
                    to $SCIPY
                }


                if (/^List-Id:.*[Pp]andas/)
                {
                    to $PANDAS
                }


                if (/^List-Id:.*pydata/)
                {
                    to $PANDAS
                }


                if (/^List-Id:.*WireGuard/)
                {
                    to $WIREGUARD
                }


                if (/^List-Id:.*FFmpeg/)
                {
                    to $FFMPEG
                }


                if (/^List-Id:.*linux-kernel/)
                {
                    to $KERNEL
                }


                if (/^List-Id:.*linux-perf/)
                {
                    to $PERFDEVEL
                }


                if (/^List-Id:.*linux-trace-users/)
                {
                    to $PERF
                }


                if (/^List-ID:.*vim/)
                {
                    EXITCODE = 0
                    exit
                }


                if (/^List-Id:.*AUR/)
                {
                    EXITCODE = 0
                    exit
                }


                if (/^List-Id:.*Tor/)
                {
                    to $TOR
                }


                if (/^List-Id:.*linux-doc/)
                {
                    to $LINUXDOC
                }


                if (/^List-Id:.*linux-toolchains/)
                {
                    to $LINUXTOOL
                }


                if (/^List-Id:.*linux-man/)
                {
                    to $LINUXMAN
                }


                if (/^List-Id:.*ZeroMQ/)
                {
                    to $ZEROMQ
                }


                if (/^List-ID:.*NixOS/)
                {
                    to $NIXOS
                }


                if (/^List-Id:.*bpf\.vger\.kernel\.org/)
                {
                    to $EBPF
                }


                if (/^List-ID:.*Python.org/)
                {
                    to $PYTHON
                }


                if (/^List-ID:.*linux-hardening.vger.kernel.org/)
                {
                    to $LINUXHARDENING
                }


                to $INBOX


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
            '';
        };

        systemd.user.timers.fetchmail = {
            Unit = {
                Description = "Timer For Gmail Fetcher";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };

            Timer = {
                OnBootSec = "4m";
            };
        };

        systemd.user.services.fetchmail = {
            Unit = {
                Description = "Gmail Fetcher";
            };

            Service = {
                Type = "exec";
                StandardOutput = "journal";
                ExecStart = "${pkgs.fetchmail}/bin/fetchmail -N -d3600";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
