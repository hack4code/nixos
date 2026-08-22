{ config, pkgs, ... }:

let
    userName = config.userName;
    vpsName = config.vpsName;
    wgServerIp4Address = config.wgServerIp4Address;
    appName = "downmovie.sh";

    downmovie = pkgs.writeShellApplication {
        name = appName;
        runtimeInputs = with pkgs; [
            rsync
            openssh
            coreutils
            procps
            gnugrep
            gnused
            libnotify
        ];
        text = ''
            SSH="${pkgs.openssh}/bin/ssh"
            RSYNC="${pkgs.rsync}/bin/rsync"

            VPS="${vpsName}"
            SOURCE="${wgServerIp4Address}::movie"
            DEST="$HOME/download/.rsync/"


            function notify {
                ${pkgs.libnotify}/bin/notify-send --icon="media-downloader" "downmovie" "$1"
            }


            function panic {
                echo "$*" 1>&2
                notify "$*"
                exit 1
            }


            for PID in $(pgrep "${appName}"); do
                if [[ $PID != "$$" ]]; then
                    echo "${appName} already running"
                    exit 0
                fi
            done


            if ! $SSH -q -o ConnectTimeout=8 $VPS exit 2>/dev/null; then
                panic "failed connecting $VPS"
            fi

            if ! [[ -d "$DEST" ]]; then
                mkdir -p "$DEST"
            fi

            # shellcheck disable=SC2016
            while ! $SSH -q -T $VPS 'test -z "$(ls -A ~/download/complete/)"' 2>/dev/null; do
                if ! $RSYNC -aqz --perms --fsync --remove-source-files --partial-dir='.rsync-partial' --filter='- *.part' --bwlimit=0 --chmod='D0700,F600' --log-file='/dev/null' "$SOURCE" "$DEST" 2>/dev/null; then
                    panic "rsync error"
                fi

                # shellcheck disable=SC2016
                $SSH -q -T $VPS 'cd ~/download/complete/ 2>/dev/null && find . -type d -empty -delete'
                if [[ -n "$($SSH -q -T $VPS 'cd ~/download/complete/ 2>/dev/null && find . -type f -name *.part')" ]]; then
                    panic "found .part files"
                fi
            done

            if [[ -n "$(ls -A "$DEST")" ]]; then
                notify "finished downloading"
                echo "finished downloading" | systemd-cat --identifier downmovie
            fi

            exit 0
        '';
    };
in
{
    home-manager.users.${userName} = {
        home.packages = [
            downmovie
        ];

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
                ExecStart = "${downmovie}/bin/${appName}";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
