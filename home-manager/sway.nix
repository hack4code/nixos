{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;

    cursor = "Adwaita";

    monitorThinkpad = config.monitorThinkpad;
    monitorSamsung = config.monitorSamsung;

    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;

    swayBin = "/home/${config.userName}/.config/sway/bin";
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
                        mode = "2160x1350@59.744Hz";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                    };

                    "${monitorSamsung}" = {
                        position = "1440,0";
                        mode = "2560x1440@59.951Hz";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                    };
                };

                keybindings =
                let
                    modifier = "Mod4";
                    swaycmd = "${swayBin}/swaycmd";
                in
                {
                    "${modifier}+left" = "focus left";
                    "${modifier}+right" = "focus right";
                    "${modifier}+up" = "focus up";
                    "${modifier}+down" = "focus down";

                    "${modifier}+return" = "exec --no-startup-id kitty --instance-group SHELL --single-instance";
                    "${modifier}+semicolon" = "exec ${swaycmd} kitty";
                    "${modifier}+apostrophe" = "workspace number 11";

                    "${modifier}+a" = "exec swaync-client -t -sw";
                    "${modifier}+d" = "exec ${swaycmd} linode togglefullscreen";
                    "${modifier}+e" = "exec ${swaycmd} ncmpcpp visualizer";
                    "${modifier}+f" = "exec ${swaycmd} btop toggle";
                    "${modifier}+g" = "exec ${swaycmd} htop togglefullscreen";
                    "${modifier}+i" = "exec firefox -P KISS --private-window";
                    "${modifier}+j" = "workspace prev_on_output";
                    "${modifier}+k" = "workspace next_on_output";

                    "${modifier}+o" = "exec wofi";
                    "${modifier}+q" = "kill";
                    "${modifier}+r" = "exec ${swaycmd} ncmpcpp togglefullscreen";
                    "${modifier}+s" = "exec swaync-client -C";
                    "${modifier}+t" = "exec ${swaycmd} ncmpcpp time";
                    "${modifier}+u" = "exec ${swaycmd} mpd reload";
                    "${modifier}+w" = "exec ${swaycmd} ncmpcpp toggle";
                    "${modifier}+x" = "exec swaymsg 'seat - cursor set 1020 650'";
                    "${modifier}+y" = "exec ${swaycmd} ncmpcpp lyrics";
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

                    "${modifier}+alt+a" = "exec ${swaycmd} camer toggle";
                    "${modifier}+alt+e" = "reload";
                    "${modifier}+alt+f" = "exec swaylock -f";
                    "${modifier}+alt+q" = "exec sway exit";
                    "${modifier}+alt+r" = "exec reboot";
                    "${modifier}+alt+s" = "exec shutdown";
                    "${modifier}+alt+t" = "exec grim -o DP-3 ~/picture/screen/screenshot.png";
                    "${modifier}+alt+j" = "exec ${swaycmd} ncmpcpp lyricsdown";
                    "${modifier}+alt+k" = "exec ${swaycmd} ncmpcpp lyricsup";

                    "${modifier}+alt+left" = "resize grow width 10";
                    "${modifier}+alt+down" = "resize shrink height 10";
                    "${modifier}+alt+up" = "resize grow height 10";
                    "${modifier}+alt+right" = "resize shrink width 10";
                };

                seat = {
                    "seat0" = {
                        xcursor_theme = "${cursor} 20";
                        hide_cursor = "when-typing enable";
                    };
                };

                bars = [ { command = "waybar"; } ];
            };

            extraConfigEarly = ''
                title_align center
                titlebar_border_thickness 1
            '';

            extraConfig = ''
                workspace 0  output "${monitorThinkpad}"
                workspace 11 output "${monitorThinkpad}"
                workspace 1  output "${monitorSamsung}"
                workspace 2  output "${monitorSamsung}"
                workspace 3  output "${monitorSamsung}"
                workspace 4  output "${monitorSamsung}"
                workspace 5  output "${monitorSamsung}"
                workspace 9  output "${monitorSamsung}"
                workspace 10 output "${monitorSamsung}"

                bindsym XF86MonBrightnessDown exec light -U 10
                bindsym XF86MonBrightnessUp exec light -A 10
                bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +10%'
                bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -10%'
                bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

                exec systemctl --user set-environment XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway SDL_VIDEODRIVER=wayland QT_QPA_PLATFORM=wayland
                exec systemctl --user import-environment DISPLAY SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
                exec hash dbus-update-activation-environment && dbus-update-activation-environment --systemd DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP WAYLAND_DISPLAY

                # exec --no-startup-id gsettings set org.gnome.desktop.interface cursor-size 32
                # exec --no-startup-id gsettings set org.gnome.desktop.interface cursor-theme ${cursor}

                exec --no-startup-id swaybg -o "${monitorSamsung}" -i "${bgSamsung}" -m fit
                exec --no-startup-id swaybg -o "eDP-1" -i "${bgThinkpad}" -m fit

                exec --no-startup-id fcitx5 -d --replace
                exec --no-startup-id wl-paste -t text --watch clipman store --no-persist

                exec --no-startup-id swaync
                exec --no-startup-id swayidle \
                    timeout 300 "${swayBin}/lock" resume "${swayBin}/resume-lock" \
                    timeout 3600 "${swayBin}/suspend" resume "${swayBin}/resume-suspend" \
                    after-resume "${swayBin}/resume-sleep"

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
            '';
        };

        home.packages = with pkgs; [
            adwaita-icon-theme
            ( callPackage ../rpcd/rpcd.nix {} )
        ];

        home.pointerCursor = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 32;
            x11 = {
                enable = true;
                defaultCursor = "Adwaita";
            };
        };

        home.stateVersion = "${version}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
