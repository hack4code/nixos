{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;

    monitorThinkpad = config.monitorThinkpad;
    monitorSamsung = config.monitorSamsung;

    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;

    cursorName = "graphite-dark-nord";

    swayctl = pkgs.writeShellApplication {
        name = "swayctl";

        runtimeInputs = with pkgs; [
            bluez
            coreutils
            curl
            ffmpeg
            gawk
            gnugrep
            procps
            systemd
            wireplumber
        ];

        text = ''
            function connect_sony {
                local T=0
                local SONY="20:64:DE:85:A4:E3"

                while [[ $(bluetoothctl info "$SONY" | awk -F : '/Connected/ {print $2}' | tr -d ' \n') != "yes" ]]; do
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


            function setup_sound {
                connect_sony
                set_sound_volume
            }


            function lock {
                pkill cmatrix
            }


            function resume_ncmpcpp {
                curl -s -o /dev/null -X GET "http://127.0.0.1:8080/ncmpcpp/resume"
            }


            function resume_system {
                curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/resume'
            }


            function resume_kremap {
                sudo systemctl restart kremap.service
            }


            function stop_suspend {
                # shellcheck disable=SC2009
                PID=$(ps aux | grep -v swayidle | grep -E '[s]wayctl suspend' | awk '{print $2}')
                if [[ -n "$PID" ]]; then
                    kill -9 "$PID"
                fi
            }


            function reboot {
                systemctl reboot
            }


            function shutdown {
                systemctl poweroff
            }


            function check_before_sleep {
                while pgrep downmovie.sh || pgrep syncdrive.sh || pgrep vps || pgrep ffmpeg || pgrep axel || pgrep nixos-rebuild; do
                    sleep 300s
                done
            }


            function system_sleep {
                curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/sleep'
            }


            function start_camer {
                local T

                local CAMER_DEST="$HOME/movie/.camer/"

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
                            resume_ncmpcpp
                            ;;

                        sleep)
                            resume_kremap
                            resume_system
                            setup_sound
                            ;;

                        suspend)
                            stop_suspend
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

                sndtimer)
                    if (($(awk '{print int($1)}' /proc/uptime) > 600)); then
                        set_sound_volume
                    fi
                    ;;

                setup)
                    case "$2" in
                        sound)
                            setup_sound
                            ;;

                        *)
                            ;;
                    esac
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
                    # shellcheck disable=SC2009
                    PID=$(ps -elf | grep -E '[f]fmpeg -f pulse' | awk '{print $4}')
                    case "$2" in
                        on)
                            if [[ -z "$PID" ]]; then
                                start_camer
                            fi
                            ;;

                        off)
                            if [[ -n "$PID" ]]; then
                                kill "$PID"
                            fi
                            ;;

                        toggle)
                            if [[ -z "$PID" ]]; then
                                start_camer
                            else
                                kill "$PID"
                            fi
                            ;;

                        *)
                            ;;
                    esac
                    ;;

            esac


            # vim: set ts=4 sw=4 sts=4 ft=bash et: #
        '';
    };
    swaycmd = "${swayctl}/bin/swayctl";
in
{
    home-manager.users.${userName} = { lib, ... }: {
        services.gnome-keyring.enable = true;
        wayland.windowManager.sway = {
            enable = true;
            systemd.enable = false;
            wrapperFeatures.gtk = true;
            config = {
                fonts = {
                    names = [ "Iosevka Term Semibold" ];
                    size = 13.0;
                };

                focus = {
                    followMouse = false;
                    mouseWarping = false;
                };

                colors = {
                    urgent = {
                        border = "#fb4934";
                        background = "#fb4934";
                        text = "#282828";
                        indicator = "#fb4934";
                        childBorder = "#fb4934";
                    };

                    focused = {
                        border = "#b8bb26";
                        background = "#282828";
                        text = "#fabd2f";
                        indicator = "#83a598";
                        childBorder = "#b8bb26";
                    };

                    unfocused = {
                        border = "#3c3836";
                        background = "#282828";
                        text = "#3c3836";
                        indicator = "#3c3836";
                        childBorder = "#3c3836";
                    };

                    focusedInactive = {
                        border = "#3c3836";
                        background = "#3c3836";
                        text = "#d5c4a1";
                        indicator = "#665c54";
                        childBorder = "#3c3836";
                    };
                };

                window = {
                    titlebar = false;
                    border = 2;
                    hideEdgeBorders = "smart";
                };

                floating = {
                    titlebar = false;
                    border = 2;
                };

                workspaceAutoBackAndForth = false;

                gaps = {
                    inner = 8;
                    top = 8;
                    bottom = 4;
                    horizontal = 16;
                };

                input = let
                    keyboard = "1:1:AT_Translated_Set_2_keyboard";
                    cherry = "1671:10:MX-LP_2.1-BT1_Keyboard";
                    touchpad = "1267:12624:ELAN0670:00_04F3:3150_Touchpad";
                    trackpoint = "2:10:TPPS/2_Elan_TrackPoint";
                in
                {
                    "${keyboard}" = {
                        xkb_layout = "us";
                        repeat_rate = "12";
                        repeat_delay = "1000";
                    };

                    "${cherry}" = {
                        xkb_layout = "us";
                        repeat_rate = "12";
                        repeat_delay = "1000";
                    };

                    "${touchpad}" = {
                        dwt = "enabled";
                        tap = "enabled";
                        natural_scroll = "enabled";
                        click_method = "button_areas";
                        accel_profile = "flat";
                        pointer_accel = "0.7";
                    };

                    "${trackpoint}" = {
                        accel_profile = "flat";
                    };
                };

                output = {
                    "${monitorThinkpad}" = {
                        position = "0,0";
                        mode = "2160x1350@60HZ";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                    };

                    "${monitorSamsung}" = {
                        position = "1440,0";
                        mode = "2560x1440@75HZ";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                        adaptive_sync = "on";
                        allow_tearing = "no";
                    };
                };

                keybindings =
                let
                    modifier = "Mod4";
                in
                {
                    "${modifier}+left" = "focus left";
                    "${modifier}+right" = "focus right";
                    "${modifier}+up" = "focus up";
                    "${modifier}+down" = "focus down";

                    "${modifier}+return" = "exec kitty";
                    "${modifier}+semicolon" = "exec ${swaycmd} kitty";
                    "${modifier}+apostrophe" = "workspace number 11";

                    "${modifier}+a" = "exec --no-startup-id swaync-client -t -sw";
                    "${modifier}+d" = "exec --no-startup-id ${swaycmd} linode togglefullscreen";
                    "${modifier}+e" = "exec --no-startup-id ${swaycmd} ncmpcpp visualizer";
                    "${modifier}+f" = "exec --no-startup-id ${swaycmd} btop toggle";
                    "${modifier}+g" = "exec --no-startup-id ${swaycmd} htop togglefullscreen";
                    "${modifier}+i" = "exec firefox -P KISS --private-window";
                    "${modifier}+j" = "workspace prev_on_output";
                    "${modifier}+k" = "workspace next_on_output";
                    "${modifier}+m" = "exec wl-kbptr -o modes=floating','click -o mode_floating.source=detect";

                    "${modifier}+o" = "exec wofi";
                    "${modifier}+q" = "kill";
                    "${modifier}+r" = "exec --no-startup-id ${swaycmd} ncmpcpp togglefullscreen";
                    "${modifier}+s" = "exec --no-startup-id swaync-client -C";
                    "${modifier}+t" = "exec --no-startup-id ${swaycmd} ncmpcpp time";
                    "${modifier}+u" = "exec --no-startup-id ${swaycmd} mpd reload";
                    "${modifier}+w" = "exec --no-startup-id ${swaycmd} ncmpcpp toggle";
                    "${modifier}+x" = "exec --no-startup-id swaymsg 'seat - cursor set 1020 650'";
                    "${modifier}+y" = "exec --no-startup-id ${swaycmd} ncmpcpp lyrics";
                    "${modifier}+z" = "exec zathura";

                    "${modifier}+0" = "workspace number 0";
                    "${modifier}+1" = "workspace number 1";
                    "${modifier}+2" = "workspace number 2";
                    "${modifier}+3" = "workspace number 3";
                    "${modifier}+4" = "workspace number 4";
                    "${modifier}+5" = "workspace number 5";
                    "${modifier}+6" = "workspace number 6";
                    "${modifier}+7" = "workspace number 7";
                    "${modifier}+8" = "workspace number 8";
                    "${modifier}+9" = "workspace number 9";

                    "${modifier}+alt+a" = "exec --no-startup-id ${swaycmd} camer toggle";
                    "${modifier}+alt+e" = "reload";
                    "${modifier}+alt+f" = "exec swaylock -f";
                    "${modifier}+alt+q" = "exec sway exit";
                    "${modifier}+alt+r" = "exec --no-startup-id ${swaycmd} reboot";
                    "${modifier}+alt+s" = "exec --no-startup-id ${swaycmd} shutdown";
                    "${modifier}+alt+t" = "exec --no-startup-id grim -o DP-3 ~/picture/screen/screenshot.png";
                    "${modifier}+alt+j" = "exec --no-startup-id ${swaycmd} ncmpcpp lyricsdown";
                    "${modifier}+alt+k" = "exec --no-startup-id ${swaycmd} ncmpcpp lyricsup";
                    "${modifier}+alt+m" = "mode Mouse";

                    "${modifier}+alt+left" = "resize grow width 10";
                    "${modifier}+alt+down" = "resize shrink height 10";
                    "${modifier}+alt+up" = "resize grow height 10";
                    "${modifier}+alt+right" = "resize shrink width 10";
                };

                seat.seat0 = {
                    xcursor_theme = "${cursorName} 20";
                    hide_cursor = "when-typing enable";
                };

                bars = [ { command = "waybar"; } ];
            };

            extraConfigEarly = ''
                title_align center
                titlebar_border_thickness 1
            '';

            extraConfig = ''
                workspace 0  output "${monitorThinkpad}"
                workspace 1  output "${monitorSamsung}"
                workspace 2  output "${monitorSamsung}"
                workspace 3  output "${monitorSamsung}"
                workspace 4  output "${monitorSamsung}"
                workspace 5  output "${monitorSamsung}"
                workspace 9  output "${monitorSamsung}"
                workspace 10 output "${monitorSamsung}"
                workspace 11 output "${monitorThinkpad}"

                mode "Mouse" {
                    bindsym Shift+a mode default, exec "wl-kbptr; swaymsg mode Mouse"

                    # Mouse move
                    bindsym h seat seat0 cursor move -15 0
                    bindsym j seat seat0 cursor move 0 15
                    bindsym k seat seat0 cursor move 0 -15
                    bindsym l seat seat0 cursor move 15 0

                    # Left button
                    bindsym s seat seat0 cursor press button1
                    bindsym --release s seat seat0 cursor release button1

                    # Middle button
                    bindsym d seat seat0 cursor press button2
                    bindsym --release d seat seat0 cursor release button2

                    # Right button
                    bindsym f seat seat0 cursor press button3
                    bindsym --release f seat seat0 cursor release button3

                    bindsym Escape mode default
                }

                bindsym XF86MonBrightnessDown exec --no-startup-id light -s sysfs/backlight/intel_backlight -U 10
                bindsym XF86MonBrightnessUp exec --no-startup-id light -s sysfs/backlight/intel_backlight -A 10
                bindsym XF86AudioRaiseVolume exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%+
                bindsym XF86AudioLowerVolume exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%-
                bindsym XF86AudioMute exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle

                for_window [window_type="dialog"] floating enable
                for_window [window_role="dialog"] floating enable

                for_window [app_id="firefox" title="^Library$"] floating enable, border pixel 1, sticky enable, move position center, resize set 60 ppt 80 ppt
                for_window [app_id="firefox" title="^File Upload$"] floating enable, border pixel 1, sticky enable, move position center, resize set 60 ppt 90 ppt
                for_window [app_id="firefox" title="^Page Info"] floating enable, border pixel 1, sticky enable, move position center
                for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable, move position 70 ppt 69 ppt, resize set 30 ppt 30 ppt

                for_window [app_id="org.fcitx.fcitx5-config-qt"] floating enable, border pixel 1, sticky enable, move position center, resize set 50 ppt 70 ppt
                for_window [app_id="org.fcitx.fcitx5-config-qt" title="^Fcitx Configuration$"] floating enable, border pixel 1, sticky enable, move position center, resize set 60 ppt 90 ppt

                for_window [app_id="floatkitty"] floating enable, border pixel 1, move position center, resize set 64 ppt 60 ppt, opacity 0.95

                exec systemctl --user set-environment XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway SDL_VIDEODRIVER=wayland QT_QPA_PLATFORM=wayland
                exec systemctl --user import-environment DISPLAY SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
                exec hash dbus-update-activation-environment && dbus-update-activation-environment --systemd DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP WAYLAND_DISPLAY

                exec --no-startup-id swaybg -o "${monitorSamsung}" -i "${bgSamsung}" -m fit
                exec --no-startup-id swaybg -o "eDP-1" -i "${bgThinkpad}" -m fill

                exec --no-startup-id fcitx5 -d --replace
                exec --no-startup-id wl-paste -t text --watch clipman store --no-persist

                exec --no-startup-id swaync
                exec --no-startup-id swayidle \
                    timeout 300 "${swaycmd} lock; swaylock -f" resume "${swaycmd} resume lock" \
                    timeout 3600 "${swaycmd} suspend" resume "${swaycmd} resume suspend" \
                    after-resume "${swaycmd} resume sleep"

                exec_always --no-startup-id ${swaycmd} setup sound

                exec_always --no-startup-id rpcd


                # vim: set ts=4 sw=4 ft=swayconfig et: #
            '';
        };

        home.file.".config/user-dirs.dirs" = {
            text = ''
                XDG_CONFIG_HOME="$HOME/.config"
                XDG_CACHE_HOME="$HOME/.cache"
                XDG_DATA_HOME="$HOME/.local/share"
                XDG_STATE_HOME="$HOME/.local/state"
                XDG_DOCUMENTS_DIR="$HOME/document"
                XDG_DOWNLOAD_DIR="$HOME/download"
                XDG_MUSIC_DIR="$HOME/music"
                XDG_VIDEOS_DIR="$HOME/movie"
                XDG_PICTURES_DIR="$HOME/picture"
                XDG_DESKTOP_DIR="$HOME/temp"
                XDG_PUBLICSHARE_DIR="$HOME/temp"
                XDG_TEMPLATES_DIR="$HOME/temp"
            '';
        };

        home.file.".config/sway/kitty/kitty.session" = {
            text = ''
                launch zsh -i -c 'kssh -t linode'
                new_tab
                launch zsh -i -c ipython
                new_tab
                launch zsh -i
                focus
            '';
        };

        home.file.".config/sway" = {
            source = ../sway;
            recursive = true;
        };

        home.activation = {
            initHome = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
                test -d book || mkdir book book/.reading
                test -d mail || mkdir mail mail/inbox mail/inbox/cur mail/inbox/new mail/inbox/tmp
                test -d movie || mkdir movie movie/.rsync movie/.camer
                test -d music || mkdir music music/lyrics music/playlist music/song music/youtube
                test -d picture || mkdir picture picture/icon picture/mpv picture/screen picture/wallpaper
                test -d temp || mkdir temp temp/drive temp/neomutt temp/test
                test -d code || mkdir code
                test -d document || mkdir document
                test -d download || mkdir download
                test -d source || mkdir source
                test -d .local/share/tpm2-tss || (mkdir -p .local/share/tpm2-tss/user/keystore .local/share/tpm2-tss/system/keystore .local/share/tpm2-tss/log; tss2_provision;)

                ${pkgs.git}/bin/git config --global user.name "code4hack"
                ${pkgs.git}/bin/git config --global user.email "code4hack+github@gmail.com"
                ${pkgs.git}/bin/git config --global init.defaultBrance main
                ${pkgs.git}/bin/git config --global pull.rebase true
            '';
        };

        home.packages = with pkgs; [
            bitwarden-cli
            cmatrix
            jupyter
            mpc
            ( callPackage ../rpcd/rpcd.nix {} )
        ];

        home.pointerCursor = {
            enable = true;
            package = pkgs.graphite-cursors;
            name = "${cursorName}";
            size = 18;
            gtk.enable = true;
        };

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
                ExecStart = "${swaycmd} sndtimer";
            };
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = "${version}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
