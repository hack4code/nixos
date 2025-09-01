{ config, pkgs-unstable, ... }:

let
    userName = config.userName;
    monitorSamsung = config.monitorSamsung;
    monitorThinkpad = config.monitorThinkpad;
in
{
    home-manager.users.${userName} = {
        programs.waybar = {
            package = pkgs-unstable.waybar;
            enable = true;
            systemd = {
                enable = false;
            };

            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    mode = "dock";
                    exclusive = true;
                    ipc = true;
                    margin = "24px 24px 0px 24px";
                    passthrough = false;

                    output = [
                        "!${monitorThinkpad}"
                        "${monitorSamsung}"
                    ];

                    modules-left = [
                        "sway/workspaces"
                    ];
                    modules-center = [ ];
                    modules-right = [
                        "network"
                        "pulseaudio"
                        "custom/notification"
                        "idle_inhibitor"
                        "clock"
                        "tray"
                    ];

                    "sway/workspaces" = {
                        disable-scroll = true;
                        disable-click = false;
                        all-outputs = false;
                        active-only = false;
                        persistent = true;
                        sort-by-number = true;
                        on-click = "activate";
                        format = "{icon}";
                        format-icons = {
                            "0" = "⓿";
                            "1" = "㊀";
                            "2" = "㊁";
                            "3" = "㊂";
                            "4" = "㊃";
                            "5" = "㊄";
                            "6" = "㊅";
                            "7" = "㊆";
                            "8" = "㊇";
                            "9" = "㊈";
                            "10" = "㊉";
                            "11" = "ⅺ";
                        };
                    };

                    "clock" = {
                        interval = 60;
                        format = "{:%H:%M}";
                        tooltip-format = "{calendar}";
                        calendar = {
                            mod = "month";
                        };
                    };

                    "network" = {
                        format = "{ifname}";
                        format-wifi ="{essid}";
                        format-disconnected = "⚠disconnected";
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
                            "default" = ["" "" ""];
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
                        tooltip = false;
                        format = "{icon}";
                        format-icons = {
                            notification = "<span foreground='#d65d01'></span>";
                            none = "";
                            dnd-notification = "";
                            dnd-none = "";
                            inhibited-notification = "<span foreground='red'></span>";
                            inhibited-none = "";
                            dnd-inhibited-notification = "";
                            dnd-inhibited-none = "";
                        };
                        return-type = "json";
                        exec-if = "which swaync-client";
                        exec = "swaync-client -swb";
                        on-click = "swaync-client -t -sw";
                        on-click-right = "swaync-client -d -sw";
                        escape = true;
                    };

                    "tray"  = {
                        spacing = 8;
                        icon-size = 22;
                    };
                };
            };

            style = ''
                @define-color fg1       #ebdbb2;
                @define-color fg2       #d5c4a1;
                @define-color fg4       #a89984;
                @define-color bg0       #282828;
                @define-color bg0_h     #1d2021;
                @define-color bg0_s     #32302f;
                @define-color orange    #d65d0e;
                @define-color red       #cc241d;
                @define-color grey      #928374;


                * {
                    font-family: "Symbols Nerd Font", "Fira Mono";
                    font-size: 16px;
                }


                window#waybar {
                    background-color: rgba(43, 48, 59, 0.0);
                    color: #ffffff;
                    transition-property: background-color;
                    transition-duration: 0.5s;
                }


                window#waybar.hidden {
                    opacity: 0.2;
                }


                #waybar.top > box.horizontal {
                    margin-left: 8pt;
                    margin-right: 8pt;
                    margin-top: 6pt;
                    background-color: rgba(0, 0, 0, 1);
                    background: linear-gradient(rgba(0, 0, 0, 1), rgba(0, 0, 0, 1)) padding-box, linear-gradient(45deg, rgba(204, 36, 29, 1.0), rgba(215, 153, 33, 1.0)) border-box;
                    border-radius: 16px;
                    border: 2px solid @grey;
                    padding: 1pt 1pt;
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
                color: @fg1;
                    letter-spacing: 0;
                    margin: 2px 8px;
                    font-weight: 500;
                }


                #tray {
                    padding: 0 24px;
                }


                #workspaces {
                    margin-left: 24px;
                }


                #workspaces button {
                    font-size: 16px;
                    font-weight: 600;
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
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
