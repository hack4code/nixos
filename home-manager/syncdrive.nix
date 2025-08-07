{ config, pkgs, ... }:

let
    userName = config.userName;

    syncdrive = pkgs.writeShellApplication {
        name = "syncdrive.sh";

        runtimeInputs = with pkgs; [
            rclone
            systemd
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
            SCP=$(command -v scp)
            RCLONE=$(command -v rclone)
            NOTIFY=$(command -v notify-send)

            VPS="linode"

            NFS_SPIDER="10.0.0.2:/export/spider"
            MOUNT_OPT="vers=4,rsize=1048576,wsize=1048576,hard,fsc,nolock,tcp,async,nocto"
            ICON="$HOME/picture/icon/network.png"

            ROOT=$($SSH -T $VPS pwd)
            R_MEMOS_DB="$ROOT/memos/memos_prod.db"
            R_SPIDER_DB="$ROOT/mongo/dump/spider.gz"

            MEMOS_PATH="$HOME/temp/drive/memos"
            SPIDER_PATH="$HOME/temp/drive/spider"
            BOOK_PATH="$HOME/book"
            SONG_PATH="$HOME/music/song"
            LYRICS_PATH="$HOME/music/lyrics"


            function notify {
                if [[ -f "$ICON" ]]; then
                    $NOTIFY --icon="$ICON" "syncdrive" "$1"
                else
                    $NOTIFY "syncdrive" "$1"
                fi
            }


            declare -A SYNCDIR=(
                ["$MEMOS_PATH"]="drive:memos"
                ["$BOOK_PATH"]="drive:book"
                ["$SONG_PATH"]="drive:song"
                ["$LYRICS_PATH"]="drive:lyrics"
                ["$SPIDER_PATH"]="drive:spider"
            )


            # shellcheck disable=SC2016
            for PID in $(pgrep -f "$(basename '$0')"); do
                if [[ $PID != "$$" ]]; then
                    exit 0
                fi
            done

            if ! $SSH -T -o ConnectTimeout=64 $VPS exit; then
                notify "connecting $VPS failed"
                exit 1
            fi

            if ! [[ -d "$MEMOS_PATH" ]]; then
                mkdir -p "$MEMOS_PATH"
            fi

            if ! [[ -d "$SPIDER_PATH" ]]; then
                mkdir -p "$SPIDER_PATH"
            fi

            if ! $SSH -T $VPS "mount -t nfs4 -l" | grep -q "$ROOT/spider"; then
                if ! $SSH -T linode "mount -t nfs -o '$MOUNT_OPT' '$NFS_SPIDER' $ROOT/spider"; then
                    notify "spider mount failed"
                    exit 1
                fi
            fi
            $SSH -T $VPS "cd $ROOT/spider; docker compose exec mongodb mongodump --quiet --gzip --username scrapy --password scrapy --db scrapy --collection spider --archive='/dump/spider.gz'"
            $SCP -q "$VPS:$R_MEMOS_DB" "$MEMOS_PATH/"
            $SCP -q "$VPS:$R_SPIDER_DB" "$SPIDER_PATH/"

            for KEY in "''${!SYNCDIR[@]}"; do
                if [[ -z "$(ls -A "$KEY" 2>/dev/null)" ]]; then
                    notify "$KEY is empty"
                    exit 1
                fi

                if ! $RCLONE sync "$KEY" "''${SYNCDIR[$KEY]}"; then
                    notify "rclone failed for syncing $KEY"
                    exit 1
                fi
            done

            echo "finished backup" | systemd-cat --identifier syncdrive


            # vim: ts=4 sw=4 sts=4 ft=bash et:
        '';
    };
in
{
    home-manager.users.${userName} = {
        home.packages = [ syncdrive ];

        systemd.user.timers.syncdrive = {
            Unit = {
                Description = "Timer For syncdrive";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };

            Timer = {
                OnCalendar = "*-*-* 16:00:00";
                Unit = "syncdrive.service";
            };
        };

        systemd.user.services.syncdrive = {
            Unit = {
                Description = "Backup Files To Google Drive";
            };

            Service = {
                Type = "simple";
                StandardOutput = "journal";
                ExecStart = "${syncdrive}/bin/syncdrive.sh";
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
