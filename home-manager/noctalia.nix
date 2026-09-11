{ config, inputs, ... }:

let
    userName = config.userName;
    userLocation = config.userLocation;
    monitorSamsung = config.monitorSamsung;
    monitorThinkpad = config.monitorThinkpad;
    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;
    bgLock = config.bgLock;
in
{
    home-manager.users.${userName} = {
        imports = [
            inputs.noctalia.homeModules.default
        ];

        programs.noctalia = {
            enable = true;

            settings = {
                bar = {
                    order = [ "main" ];
                    default = {
                        enabled = true;
                        position = "top";
                        layer = "top";
                        thickness = 36;
                        background_opacity = 0.9;
                        border = "outline";
                        border_width = 2;
                        shadow = true;
                        widget_spacing = 8;
                        font_weight = 500;
                        font_family = "Fira Sans";
                        capsule = false;
                        start = [
                            "workspaces"
                        ];
                        center = [ "active_window" ];
                        end = [
                            "network"
                            "bluetooth"
                            "volume"
                            "notifications"
                            "clock"
                            "tray"
                        ];

                        monitor."${monitorThinkpad}" = {
                            match = monitorThinkpad;
                            enabled = false;
                        };
                    };
                };

                location = {
                    auto_locate = false;
                    address = userLocation;
                };

                idle = {
                    pre_action_fade_seconds = 2.0;
                    behavior_order = [
                        "screen-off"
                        "lock"
                        "lock-and-suspend"
                    ];
                    behavior = {
                        lock = {
                            action = "lock";
                            enabled = true;
                            timeout = 600;
                        };
                        screen-off = {
                            action = "screen_off";
                            enabled = true;
                            timeout = 600;
                        };
                        lock-and-suspend = {
                            action = "lock_and_suspend";
                            enabled = true;
                            timeout = 3600;
                            resume_command = "swayctl resume suspend";
                        };
                    };
                };

                lockscreen = {
                    enabled = true;
                    blurred_desktop = false;
                    fingerprint = true;
                    lock_before_suspend = true;
                    wallpaper = bgLock;
                    monitors = [
                        monitorThinkpad
                    ];
                };

                theme = {
                    builtin = "Gruvbox";
                    mode = "dark";
                };

                wallpaper = {
                    enabled = true;
                    per_monitor_directories = true;
                    transition_duration = 100;
                    transition_on_startup = true;
                    monitor = {
                        "${monitorSamsung}" = {
                            directory = "~/.config/sway/wallpaper/dp-3";
                            fill_color = "primary";
                        };

                        "${monitorThinkpad}" = {
                            directory = "~/.config/sway/wallpaper/edp-1";
                            fill_color = "secondary";
                        };
                    };

                    monitors = {
                        "${monitorSamsung}" = {
                            path = bgSamsung;
                        };

                        "${monitorThinkpad}" = {
                            path = bgThinkpad;
                        };
                    };
                };

                notification = {
                    monitors = [ monitorSamsung ];
                    position = "top_center";
                };

                widget = {
                    workspaces = {
                        font_family = "Fira Mono";
                        font_weight = 500;
                    };

                    active_window = {
                        anchor = true;
                        capsule = true;
                        capsule_opacity = 0.9;
                        font_family = "Adwaita Sans";
                        font_weight = 500;
                        icon_size = 18;
                        interactive = false;
                        max_length = 300;
                        title_scroll = "on_hover";
                    };
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
