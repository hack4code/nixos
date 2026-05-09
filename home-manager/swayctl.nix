{ config, pkgs, ... }:

let
    userName = config.userName;
    bgThinkpad = config.bgThinkpad;
    bgLock = config.bgLock;
    monitorThinkpad = config.monitorThinkpad;
in
{
    home-manager.users.${userName} = {
        home.packages = [
            (
                pkgs.writeShellApplication {
                    name = "swayctl";

                    runtimeInputs = with pkgs; [
                        coreutils
                        curl
                        ffmpeg
                        gawk
                        gnugrep
                        procps
                        systemd
                    ];

                    text =
                    let
                        noctalia-ipc = "noctalia-shell ipc call";
                    in
                    ''
                        function lock {
                            # ${noctalia-ipc} wallpaper set "${bgLock}" ${monitorThinkpad}
                            pkill cmatrix
                        }


                        function resume_ncmpcpp {
                            curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/ncmpcpp/resume'
                        }


                        function resume_system {
                            curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/resume'
                        }


                        function resume_kremap {
                            sudo systemctl restart kremap.service
                        }


                        function resume_lock {
                            # ${noctalia-ipc} wallpaper set "${bgThinkpad}" ${monitorThinkpad}
                            resume_ncmpcpp
                            resume_kremap
                        }


                        function resume_suspend {
                            resume_system
                            resume_kremap
                        }


                        function reboot {
                            systemctl reboot
                        }


                        function shutdown {
                            systemctl poweroff
                        }


                        function check_before_sleep {
                            while pgrep downmovie || pgrep syncdrive || pgrep vps || pgrep rtorrent || pgrep ffmpeg || pgrep nixos-rebuild || pgrep axel; do
                                sleep 300s
                            done
                        }


                        function system_sleep {
                            curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/sleep'
                        }


                        function start_camer {
                            local T

                            local CAMER_DEST="$HOME/movie/Camera/"

                            if ! [[ -d "$CAMER_DEST" ]]; then
                                mkdir -p "$CAMER_DEST"
                            fi

                            T=$(date +'%F-%H-%M')
                            local MICROPHONE="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"
                            ffmpeg -f pulse -i "$MICROPHONE" -f video4linux2 -s 1280x720 -i /dev/video0 "$CAMER_DEST/$T.mkv"
                        }


                        function set_mpd {
                            curl -s -o /dev/null -X GET "http://127.0.0.1:8080/mpd/$1"
                        }


                        function set_ncmpcpp {
                            curl -s -o /dev/null -X GET "http://127.0.0.1:8080/ncmpcpp/$1"
                        }


                        function toggle_fullscreen {
                            curl -s -o /dev/null -X POST -H "Content-Type: application/json" -d "{\"app_id\": \"$1\"}" "http://127.0.0.1:8080/system/fullscreen/toggle"
                        }


                        function launch_kitty {
                            curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/launch/floatingkitty'
                        }

                        function toggle_btop {
                            curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/toggle/btop'
                        }

                        function camer_pid {
                            # shellcheck disable=SC2009
                            ps -elf | grep -E '[f]fmpeg -f pulse' | awk '{print $4}'
                        }


                        case "$1" in
                            reboot)
                                reboot
                                ;;

                            shutdown)
                                shutdown
                                ;;

                            lock)
                                lock
                                ;;

                            resume)
                                case "$2" in
                                    lock)
                                        resume_lock
                                        ;;

                                    sleep)
                                        ;;

                                    suspend)
                                        resume_suspend
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            suspend)
                                check_before_sleep
                                system_sleep
                                systemctl sleep
                                ;;

                            mpd)
                                case "$2" in
                                    reload)
                                        set_mpd reload
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            ncmpcpp)
                                case "$2" in
                                    toggle|visualizer|togglefullscreen|time|lyrics|lyricsup|lyricsdown)
                                        set_ncmpcpp "$2"
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            htop)
                                case "$2" in
                                    togglefullscreen)
                                        toggle_fullscreen "htop"
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            btop)
                                case "$2" in
                                    toggle)
                                        toggle_btop
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            linode)
                                case "$2" in
                                    togglefullscreen)
                                        toggle_fullscreen "linode"
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;

                            kitty)
                                launch_kitty
                                ;;

                            camer)
                                case "$2" in
                                    on)
                                        if [[ -z "$(camer_pid)" ]]; then
                                            start_camer
                                        fi
                                        ;;

                                    off)
                                        if [[ -n "$(camer_pid)" ]]; then
                                            kill "$(camer_pid)"
                                        fi
                                        ;;

                                    toggle)
                                        if [[ -z "$(camer_pid)" ]]; then
                                            ${noctalia-ipc} idleInhibitor enable
                                            start_camer
                                        else
                                            ${noctalia-ipc} idleInhibitor disable
                                            kill "$(camer_pid)"
                                        fi
                                        ;;

                                    *)
                                        ;;
                                esac
                                ;;
                        esac
                    '';
                }
            )
        ];

    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
