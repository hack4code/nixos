{ config, pkgs-stable, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;

    downmovie = pkgs-stable.writeShellApplication {
        name = "downmovie.sh";
        runtimeInputs = with pkgs-stable; [
            rsync
            openssh
            coreutils
            procps
            gnugrep
            gnused
            libnotify
        ];
        text = ''
            TSS2_FAPICONF=$(grep -F FAPICONF /etc/set-environment | cut -d = -f 2 | sed 's/"//g')
            export TSS2_FAPICONF


            SSH=$(command -v ssh)
            RSYNC=$(command -v rsync)
            NOTIFY=$(command -v notify-send)

            VPS="linode"
            SOURCE="10.0.0.1::movie"
            DEST="$HOME/movie/.rsync/"
            ICON="$HOME/picture/icon/network.png"


            function notify {
                if [[ -f "$ICON" ]]; then
                    $NOTIFY --icon="$ICON" "downmovie" "$1"
                else
                    $NOTIFY "downmovie" "$1"
                fi
            }


            # shellcheck disable=SC2016
            for PID in $(pgrep -f "$(basename '$0')"); do
                if [[ $PID != "$$" ]]; then
                    echo "downmovie already running"
                    exit 0
                fi
            done


            if ! $SSH -q -o ConnectTimeout=8 $VPS exit; then
                notify "failed connecting $VPS"
                exit 1
            fi

            if ! [[ -d "$DEST" ]]; then
                mkdir -p "$DEST"
            fi

            # shellcheck disable=SC2016
            while ! $SSH -q -T $VPS 'test -z "$(ls -A ~/download/complete/)"'; do
                if $RSYNC -aqz --perms --fsync --remove-source-files --partial-dir='.rsync-partial' --filter='- *.part' --bwlimit=0 --chmod='D0700,F600' --log-file='/dev/null' "$SOURCE" "$DEST"; then
                    notify "finished movie downloading"
                else
                    echo "rsync error" 1>&2
                    notify "rsync error"
                    exit 2
                fi
                # shellcheck disable=SC2016
                $SSH -q -T $VPS 'cd ~/download/complete/ && find . -type d -empty -delete'
                if [[ -n "$($SSH -q -T $VPS 'cd ~/download/complete/ && find . -type f -name *.part')" ]]; then
                    echo "found .part files" 1>&2
                    notify "found .part files"
                    exit 3
                fi
            done

            exit 0


            # vim: ts=4 sw=4 sts=4 ft=bash et:
        '';
    };
in
{
    home-manager.users.${userName} = {
        home.packages = [ downmovie ];

        systemd.user.timers.downmovie = {
            Unit = {
                Description = "Timer For downmovie";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };

            Timer = {
                OnBootSec = "3m";
                OnUnitActiveSec = "1h";
                Unit = "downmovie.service";
            };
        };

        systemd.user.services.downmovie = {
            Unit = {
                Description = "Download Movie From Linode";
            };

            Service = {
                Type = "simple";
                StandardOutput = "journal";
                ExecStart = "${downmovie}/bin/downmovie.sh";
            };
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
