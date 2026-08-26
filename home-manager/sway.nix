{ config, pkgs, lib, ... }:

let
    userName = config.userName;

    monitorThinkpad = config.monitorThinkpad;
    monitorSamsung = config.monitorSamsung;

    keyboard = config.keyboard;
    cherry = config.cherry;
    touchpad = config.touchpad;
    trackpoint = config.trackpoint;

    cursorName = config.cursorName;
in
{
    systemd.user.services.cliphist.wantedBy = lib.mkForce [];

    home-manager.users.${userName} = {
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
                {
                    ${keyboard} = {
                        xkb_layout = "us";
                        repeat_rate = "12";
                        repeat_delay = "1000";
                    };

                    ${cherry} = {
                        xkb_layout = "us";
                        repeat_rate = "12";
                        repeat_delay = "1000";
                    };

                    ${touchpad} = {
                        dwt = "enabled";
                        tap = "enabled";
                        natural_scroll = "enabled";
                        click_method = "button_areas";
                        accel_profile = "flat";
                        pointer_accel = "0.7";
                    };

                    ${trackpoint} = {
                        accel_profile = "flat";
                    };
                };

                output = {
                    ${monitorThinkpad} = {
                        position = "0,0";
                        mode = "2160x1350@60HZ";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                        adaptive_sync = "on";
                        max_render_time = "off";
                        allow_tearing = "no";
                    };

                   ${monitorSamsung} = {
                        position = "1440,0";
                        mode = "2560x1440@75HZ";
                        scale = "1.5";
                        scale_filter = "smart";
                        subpixel = "rgb";
                        adaptive_sync = "off";
                        max_render_time = "off";
                        allow_tearing = "no";
                    };
                };

                keybindings =
                let
                    modifier = "Mod4";
                    firefox = "${pkgs.firefox}/bin/firefox";
                    grim = "${pkgs.grim}/bin/grim";
                    wl-kbptr = "${pkgs.wl-kbptr}/bin/wl-kbptr";
                    sherlock = "${pkgs.sherlock-launcher}/bin/sherlock";
                    # wofi = "${pkgs.wofi}/bin/wofi";
                    zathura = "${pkgs.zathura}/bin/zathura";
                    noctalia-ipc = "noctalia-shell ipc call";
                in
                {
                    "${modifier}+left" = "focus left";
                    "${modifier}+right" = "focus right";
                    "${modifier}+up" = "focus up";
                    "${modifier}+down" = "focus down";

                    "${modifier}+return" = "exec kitty";
                    "${modifier}+semicolon" = "exec ${noctalia-ipc} launcher clipboard";
                    "${modifier}+apostrophe" = "workspace number 10";
                    "${modifier}+comma" = "workspace number 11";
                    "${modifier}+period" = "workspace number 12";

                    "${modifier}+a" = "exec --no-startup-id ${noctalia-ipc} notifications toggleHistory";
                    "${modifier}+s" = "exec --no-startup-id ${noctalia-ipc} plugin:translator toggle zh";
                    "${modifier}+d" = "exec --no-startup-id swayctl linode togglefullscreen";
                    "${modifier}+e" = "exec --no-startup-id swayctl ncmpcpp visualizer";
                    "${modifier}+f" = "exec --no-startup-id swayctl btop toggle";
                    "${modifier}+g" = "exec --no-startup-id swayctl htop togglefullscreen";
                    "${modifier}+i" = "exec ${firefox} -P TOR";
                    "${modifier}+j" = "workspace prev_on_output";
                    "${modifier}+k" = "workspace next_on_output";
                    "${modifier}+m" = "exec ${wl-kbptr} -o modes=floating','click -o mode_floating.source=detect";
                    "${modifier}+n" = "exec ${wl-kbptr} -o modes=tile','click";

                    "${modifier}+o" = "exec --no-startup-id ${sherlock}";
                    # "${modifier}+o" = "exec --no-startup-id ${wofi}";
                    "${modifier}+q" = "kill";
                    "${modifier}+r" = "exec --no-startup-id swayctl ncmpcpp togglefullscreen";
                    "${modifier}+t" = "exec --no-startup-id swayctl ncmpcpp time";
                    "${modifier}+u" = "exec --no-startup-id swayctl mpd reload";
                    "${modifier}+w" = "exec --no-startup-id swayctl ncmpcpp toggle";
                    "${modifier}+x" = "exec --no-startup-id swaymsg 'seat - cursor set 1020 650'";
                    "${modifier}+y" = "exec --no-startup-id swayctl ncmpcpp lyrics";
                    "${modifier}+z" = "exec ${zathura}";

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

                    "${modifier}+alt+semicolon" = "exec swayctl kitty";
                    "${modifier}+alt+a" = "exec --no-startup-id swayctl camer toggle";
                    "${modifier}+alt+e" = "reload";
                    "${modifier}+alt+f" = "exec ${noctalia-ipc} lockScreen lock";
                    "${modifier}+alt+h" = "exec ${noctalia-ipc} idleInhibitor toggle";
                    "${modifier}+alt+q" = "exec sway exit";
                    "${modifier}+alt+r" = "exec --no-startup-id swayctl reboot";
                    "${modifier}+alt+s" = "exec --no-startup-id swayctl shutdown";
                    "${modifier}+alt+c" = "exec --no-startup-id ${noctalia-ipc} notifications clear";
                    "${modifier}+alt+t" = "exec --no-startup-id ${grim} -o DP-3 ~/picture/screen/screenshot.png";
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

                bars = [ ];
            };

            extraConfigEarly = ''
                title_align center
                titlebar_border_thickness 1
            '';

            extraConfig =
            let
                xbacklight = "${pkgs.acpilight}/bin/xbacklight";
                wpctl = "${pkgs.wireplumber}/bin/wpctl";
                sherlock = "${pkgs.sherlock-launcher}/bin/sherlock";
            in
            ''
                workspace 0  output "${monitorThinkpad}"
                workspace 1  output "${monitorSamsung}"
                workspace 2  output "${monitorSamsung}"
                workspace 3  output "${monitorSamsung}"
                workspace 4  output "${monitorSamsung}"
                workspace 5  output "${monitorSamsung}"
                workspace 6  output "${monitorSamsung}"
                workspace 7  output "${monitorSamsung}"
                workspace 8  output "${monitorSamsung}"
                workspace 9  output "${monitorSamsung}"
                workspace 10 output "${monitorSamsung}"
                workspace 11 output "${monitorThinkpad}"
                workspace 12 output "${monitorThinkpad}"

                bindsym XF86MonBrightnessDown exec --no-startup-id ${xbacklight} -dec 10
                bindsym XF86MonBrightnessUp exec --no-startup-id ${xbacklight} -inc 10
                bindsym XF86AudioRaiseVolume exec --no-startup-id ${wpctl} set-volume @DEFAULT_SINK@ 10%+
                bindsym XF86AudioLowerVolume exec --no-startup-id ${wpctl} set-volume @DEFAULT_SINK@ 10%-
                bindsym XF86AudioMute exec --no-startup-id ${wpctl} set-mute @DEFAULT_SINK@ toggle

                for_window [window_type="dialog"] floating enable
                for_window [window_role="dialog"] floating enable
                for_window [app_id="firefox" title="^Library$"] floating enable, border pixel 2, move position center, resize set 60 ppt 80 ppt
                for_window [app_id="firefox" title="^File Upload$"] floating enable, border pixel 2, move position center, resize set 60 ppt 90 ppt
                for_window [app_id="firefox" title="^Page Info"] floating enable, border pixel 1,  move position center
                for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable, move position 70 ppt 69 ppt, resize set 30 ppt 30 ppt
                for_window [app_id="org.fcitx."] floating enable, border pixel 1, move position center, resize set 50 ppt 80 ppt
                for_window [app_id="org.fcitx." title="^Fcitx Configuration$"] floating enable, border pixel 1, move position center, resize set 60 ppt 96 ppt
                for_window [app_id="floatkitty"] floating enable, border pixel 1, move position center, resize set 80 ppt 60 ppt, opacity 0.98
                for_window [app_id="org.wireshark.Wireshark" title=".+Capture.Options$"] floating enable, move position center, resize set 80 ppt 96 ppt
                for_window [title="^PCSX2"] floating enable, border pixel 2, move position center, resize set 60 ppt 80 ppt
                for_window [title="^PCSX2 v2"] floating disable
                for_window [app_id="Cemu" title="Title Manager"] floating enable, border pixel 1, resize width 80 ppt, move position center
                for_window [app_id="Cemu" title="Graphic packs"] floating enable, border pixel 1, resize set 75 ppt 90 ppt, move position center
                for_window [class="Ryujinx" title=".+Settings$"] floating enable, border pixel 1, resize set 64 ppt 85 ppt, move position center
                for_window [class="Ryujinx" title="^Settings.+"] floating enable, border pixel 1, resize set 64 ppt 85 ppt, move position center
                for_window [floating workspace="9" shell="xdg_shell" title="^Settings$"] border pixel 1, resize set 64 ppt 96 ppt, move position center
                for_window [app_id="file_chooser" title="termfilechooser"] floating enable, border pixel 2, move position center, resize set 80 ppt 72 ppt, opacity 0.99
                for_window [app_id="com.usebottles.bottles"] move workspace 9
                for_window [app_id="net.lutris.Lutris"] move workspace 9

                exec --no-startup-id systemctl --user set-environment XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway SDL_VIDEODRIVER=wayland QT_QPA_PLATFORM=wayland
                exec --no-startup-id systemctl --user import-environment DISPLAY SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
                exec --no-startup-id hash dbus-update-activation-environment && dbus-update-activation-environment --systemd DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP WAYLAND_DISPLAY

                exec --no-startup-id systemctl --user restart cliphist.service

                exec_always --no-startup-id runshell
                exec_always --no-startup-id rpcd
                exec --no-startup-id fcitx5 -d --replace --disable Clipboard -s 4
                exec --no-startup-id ${sherlock} --daemonize
                exec --no-startup-id bash -c "sleep 2s; sndctl setup"
            '';
        };


        # home.file.".config/sway/kitty/kitty.session" = {
        #     executable = false;
        #     force = true;
        #     text = ''
        #         launch zsh -i -c 'kssh -t linode'
        #         new_tab
        #         launch zsh -i -c ipython
        #         new_tab
        #         launch zsh -i
        #         focus
        #     '';
        # };

        home.file.".config/sway" = {
            force = true;
            source = ./sway;
            recursive = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
