{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
    monitorSamsung = config.monitorSamsung;
    monitorThinkpad = config.monitorThinkpad;
in
{
    home-manager.users.${userName} = {
        programs.waybar = {
            enable = true;
            systemd.enable = false;
            settings = {
                mainBar = {
                    layer= "top";
                    output = [ "!${monitorThinkpad}" "${monitorSamsung}" ];
                    position= "top";
                    mode= "dock";
                    exclusive= true;
                    ipc= true;
                    modules-left= [ "sway/workspaces" ];
                    modules-center= [ ];
                    modules-right= [ "network" "pulseaudio" "custom/notification" "idle_inhibitor" "clock" "tray" ];
                    margin= "24px 24px 0px 24px";

                    "sway/workspaces" = {
                        disable-scroll= true;
                        disable-click= false;
                        format= "{icon}";
                        format-icons= {
                            "0" = "㉧";
                            "1" = "⚀";
                            "2" = "⚁";
                            "3" = "⚂";
                            "4" = "⚃";
                            "5" = "⚄";
                            "6" = "⚅";
                            "7" = "𓅿";
                            "8" = "𓆦";
                            "9" = "𓅐";
                        };
                    };

                    "clock" = {
                        interval = 60;
                        format = "{:%H:%M}";
                        tooltip-format = "<small>{calendar}</small>";
                        calendar = {
                            mod = "month";
                            today = "<b><u>{}</u></b>";
                        };
                    };

                    "network" = {
                        format = "{ifname}";
                        format-wifi ="{essid}";
                        format-disconnected = "⚠ Disconnected";
                        tooltip-format = "{ifname} via {gwaddr}";
                    };

                    "pulseaudio" = {
                        format = "{icon}{volume}%";
                        format-bluetooth = "{icon}{volume}%";
                        format-headphone = "{icon}{volume}%";
                        format-source = "{volume}%";
                        format-icons = {
                            "format-muted" = "";
                            "hands-free" = "וֹ";
                            "headset" = "";
                            "phone" = "";
                            "portable" = "";
                            "car" = "";
                            "speaker" = "";
                            "hifi" = "";
                            "hdmi" = "";
                            "default" = [ "" "" "" "" ];
                        };
                    };

                    "idle_inhibitor" = {
                        format = "{icon}";
                        format-icons = {
                            deactivated = "";
                            activated = "<span foreground='red'></span>";
                        };
                    };

                    "custom/notification" = {
                        tooltip = true;
                        format = "{icon}";
                        format-icons = {
                            notification = "<span foreground='#d65d01'></span>";
                            none = "";
                            inhibited-notification = "<span foreground='red'></span>";
                            inhibited-none = "";
                        };
                        return-type = "json";
                        exec-if = "which swaync-client";
                        exec = "swaync-client -swb";
                        on-click = "swaync-client -t -sw";
                        escape = true;
                    };

                    "tray"  = {
                        icon-size = 18;
                        spacing = 10;
                    };
                };
            };

            style =
                ''
                @define-color fg1       #ebdbb2;
                @define-color fg2       #d5c4a1;
                @define-color fg4       #a89984;
                @define-color bg0       #282828;
                @define-color bg0_h     #1d2021;
                @define-color bg0_s     #32302f;
                @define-color orange    #d65d0e;
                @define-color red       #cc241d;
                @define-color grey      #928374;

                window#waybar {
                    border: 1px solid @grey;
                    border-radius: 0px;
                    background: @bg0;
                }

                #tray,
                #idle_inhibitor,
                #custom-notification,
                #clock,
                #battery,
                #cpu,
                #memory,
                #network,
                #pulseaudio {
                    font-family: "Symbols Nerd Font", "Fira Mono";
                    font-size: 16px;
                    font-weight: 500;
                    letter-spacing: 0;
                    color: @fg1;
                    margin: 2px 8px;
                }

                #tray {
                    padding: 0 24px;
                }

                #workspaces {
                    margin-left: 24px;
                }

                #workspaces button {
                    font-size: 16px;
                    font-family: Twemoji Mozilla;
                    font-weight: 300;
                    color: @fg1;
                    padding: 0px 4px;
                    margin: 6px 4px;
                    background: transparent;
                }

                #workspaces button.focused {
                    color: @bg0_h;
                    background-color: @fg1;
                }

                #network.disconnected {
                    color: @red;
                }

                @keyframes blink {
                    to {
                        color: @red;
                        background-color: @bg0_h;
                    }
                }

                #battery.warning:not(.charging),
                #battery.critical:not(.charging) {
                    animation-name: blink;
                    animation-duration: 4s;
                    animation-timing-function: linear;
                    animation-iteration-count: infinite;
                    animation-direction: alternate;
                }
            '';
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
