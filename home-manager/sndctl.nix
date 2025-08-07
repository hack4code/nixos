{ config, pkgs, ... }:

let
    userName = config.userName;
    sndctl = pkgs.writeShellApplication {
        name = "sndctl";
        runtimeInputs = with pkgs; [
            bluez-experimental
            coreutils
            gawk
            wireplumber
        ];

        text = ''
            function connect_sony {
                local T=0
                local SONY="20:64:DE:85:A4:E3"

                while [[ $(bluetoothctl info $SONY | awk -F : '/Connected/ {print $2; exit}' | tr -d ' \n') != "yes" ]]; do
                    bluetoothctl connect "$SONY" &>/dev/null
                    sleep 2s
                    T=$((T + 1))
                    if ((T > 60)); then
                        return
                    fi
                done
            }


            function set_sound_volume {
                local H

                H=$(date +'%k')
                if ((H >= 5)) && ((H < 18)); then
                    wpctl set-volume @DEFAULT_SINK@ 80%
                else
                    wpctl set-volume @DEFAULT_SINK@ 60%
                fi
            }


            case "$1" in
                setup)
                    connect_sony
                    sleep 2s
                    set_sound_volume
                    ;;

                timer)
                    if (($(awk '{print int($1)}' /proc/uptime) > 600)); then
                        set_sound_volume
                    fi
                    ;;

                *)
                    ;;
            esac
        '';
    };
in
{
    home-manager.users.${userName} = {
        home.packages = [
            sndctl
        ];

        systemd.user.timers.sndvolume = {
            Unit = {
                Description = "Timer For Sound Volume";
            };

            Install = {
                WantedBy = [ "timers.target" ];
            };

            Timer = {
                OnCalendar = "*-*-* *:00:00";
            };
        };

        systemd.user.services.sndvolume = {
            Unit = {
                Description = "Set Sound Volume On Time";
            };

            Service = {
                Type = "simple";
                StandardOutput = "journal";
                ExecStart = "${sndctl}/bin/sndctl timer";
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
