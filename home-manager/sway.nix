{ config, pkgs-stable, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;

    monitorThinkpad = config.monitorThinkpad;
    monitorSamsung = config.monitorSamsung;
    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;

    cursorName = "graphite-dark-nord";
in
{
    home-manager.users.${userName} = { lib, ... }:
    {
        services = {
            gnome-keyring = {
                enable = true;
            };
        };

        wayland.windowManager.sway = {
            enable = true;

            systemd = {
                enable = false;
            };

            wrapperFeatures = {
                gtk = true;
            };

            config = {
                fonts = {
                    names = [
                        "Iosevka Term Semibold"
                    ];
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

                input =
                let
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
                    "${modifier}+semicolon" = "exec swayctl kitty";
                    "${modifier}+apostrophe" = "workspace number 11";

                    "${modifier}+a" = "exec --no-startup-id swaync-client -t -sw";
                    "${modifier}+d" = "exec --no-startup-id swayctl linode togglefullscreen";
                    "${modifier}+e" = "exec --no-startup-id swayctl ncmpcpp visualizer";
                    "${modifier}+f" = "exec --no-startup-id swayctl btop toggle";
                    "${modifier}+g" = "exec --no-startup-id swayctl htop togglefullscreen";
                    "${modifier}+i" = "exec firefox -P KISS --private-window";
                    "${modifier}+j" = "workspace prev_on_output";
                    "${modifier}+k" = "workspace next_on_output";
                    "${modifier}+m" = "exec wl-kbptr -o modes=floating','click -o mode_floating.source=detect";

                    "${modifier}+o" = "exec wofi";
                    "${modifier}+q" = "kill";
                    "${modifier}+r" = "exec --no-startup-id swayctl ncmpcpp togglefullscreen";
                    "${modifier}+s" = "exec --no-startup-id swaync-client -C";
                    "${modifier}+t" = "exec --no-startup-id swayctl ncmpcpp time";
                    "${modifier}+u" = "exec --no-startup-id swayctl mpd reload";
                    "${modifier}+w" = "exec --no-startup-id swayctl ncmpcpp toggle";
                    "${modifier}+x" = "exec --no-startup-id swaymsg 'seat - cursor set 1020 650'";
                    "${modifier}+y" = "exec --no-startup-id swayctl ncmpcpp lyrics";
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

                    "${modifier}+alt+a" = "exec --no-startup-id swayctl camer toggle";
                    "${modifier}+alt+e" = "reload";
                    "${modifier}+alt+f" = "exec swaylock -f";
                    "${modifier}+alt+q" = "exec sway exit";
                    "${modifier}+alt+r" = "exec --no-startup-id swayctl reboot";
                    "${modifier}+alt+s" = "exec --no-startup-id swayctl shutdown";
                    "${modifier}+alt+t" = "exec --no-startup-id grim -o DP-3 ~/picture/screen/screenshot.png";
                    "${modifier}+alt+j" = "exec --no-startup-id swayctl ncmpcpp lyricsdown";
                    "${modifier}+alt+k" = "exec --no-startup-id swayctl ncmpcpp lyricsup";
                    "${modifier}+alt+m" = "mode Mouse";

                    "${modifier}+alt+left" = "resize grow width 10";
                    "${modifier}+alt+down" = "resize shrink height 10";
                    "${modifier}+alt+up" = "resize grow height 10";
                    "${modifier}+alt+right" = "resize shrink width 10";
                };

                seat = {
                    seat0 = {
                        xcursor_theme = "${cursorName} 20";
                        hide_cursor = "when-typing enable";
                    };
                };

                bars = [
                    {
                        command = "waybar";
                    }
                ];
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

                exec swaybg -o "${monitorSamsung}" -i "${bgSamsung}" -m fit
                exec swaybg -o "eDP-1" -i "${bgThinkpad}" -m fill

                exec --no-startup-id wl-paste -t text --watch clipman store --no-persist
                exec fcitx5 -d --replace

                exec swaync
                exec swayidle \
                    timeout 300 "swayctl lock; swaylock -f" resume "swayctl resume lock" \
                    timeout 3600 "swayctl suspend" resume "swayctl resume suspend" \
                    after-resume "swayctl resume sleep; sndctl setup"

                exec_always --no-startup-id sndctl setup

                exec_always --no-startup-id rpcd


                # vim: set ts=4 sw=4 ft=swayconfig et: #
            '';
        };

        home.file.".config/user-dirs.dirs" = {
            executable = false;
            force = true;
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
            executable = false;
            force = true;
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
            force = true;
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
            '';
        };

        home = {
            packages = with pkgs-stable; [
                bitwarden-cli
                cmatrix
                jupyter
                mpc
                (
                    callPackage ../rpcd/rpcd.nix {}
                )
            ];

            pointerCursor = {
                enable = true;
                package = pkgs-stable.graphite-cursors;
                name = "${cursorName}";
                size = 18;
                gtk = {
                    enable = true;
                };
            };
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = "${version}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
