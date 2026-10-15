{ config, inputs, ... }:

let
    userName = config.userName;
    userLocation = config.userLocation;
    monitorSamsung = config.monitorSamsung;
    monitorThinkpad = config.monitorThinkpad;
    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;
    bgLock = config.bgLock;
    userAvatarImage = config.userAvatarImage;
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
                        background_opacity = 0.99;
                        border = "outline";
                        border_width = 2;
                        shadow = true;
                        capsule = false;
                        widget_spacing = 8;
                        margin_ends = 20;
                        font_weight = 600;
                        font_family = "Iosevka";

                        start = [
                            "launcher"
                            "workspaces"
                        ];
                        center = [
                            "active_window"
                        ];
                        end = [
                            "network"
                            "bluetooth"
                            "volume"
                            "caffeine"
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
                    blur_intensity = 0.01;
                    tint_intensity = 0.3;
                    lock_before_suspend = true;
                    fingerprint = true;
                    wallpaper = bgLock;
                    monitors = [
                        monitorThinkpad
                    ];
                };

                theme = {
                    mode = "dark";
                    shell_mode = "follow";
                    builtin = "Gruvbox";
                    pure_black_dark = false;
                };

                wallpaper = {
                    enabled = true;
                    per_monitor_directories = true;
                    transition_duration = 100;
                    transition_on_startup = true;
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
                    monitors = [
                        monitorSamsung
                    ];
                    position = "top_center";
                    filter = {
                        firefox = {
                            enabled = true;
                            match = "firefox";
                            allow_permanent = false;
                            override_duration = 5000;
                        };
                    };
                };

                shell = {
                    font_family = "Adwaita Sans";
                    avatar_path = userAvatarImage;

                    clipboard_history_max_entries = 1024;

                    animation = {
                        enabled = true;
                        speed = 0.5;
                    };

                    panel = {
                        transparency_mode = "solid";
                        launcher_placement = "attached";
                        open_near_click_control_center = true;
                        open_near_click_launcher = true;
                    };

                    keyboard_layout = {
                        custom_labels = {
                            "English (US)" = "EN";
                        };
                    };

                    launcher = {
                        app_grid = true;
                        categories = false;
                        compact = false;
                        show_icons = true;
                        show_app_origin_indicator = false;
                    };
                };

                widget = {
                    launcher = {
                        glyph = "noctalia";
                    };

                    workspaces = {
                        font_family = "Fira Mono";
                        font_weight = 500;
                    };

                    active_window = {
                        anchor = true;
                        capsule = true;
                        capsule_opacity = 0.9;
                        font_family = "MiSans";
                        font_weight = 500;
                        icon_size = 20;
                        max_length = 500;
                        title_scroll = "on_hover";
                    };

                    tray = {
                        font_family = "MiSans";
                        font_weight = 600;
                    };
                };

                keybinds = {
                    delete = [
                        "Delete"
                        "Ctrl+d"
                    ];

                    down = [
                        "Down"
                        "Ctrl+n"
                    ];

                    up = [
                        "Up"
                        "Ctrl+p"
                    ];

                    left = [
                        "Left"
                        "Ctrl+h"
                    ];

                    right = [
                        "Right"
                        "Ctrl+l"
                    ];

                    tab_next = [
                        "Tab"
                        "Ctrl+j"
                    ];

                    tab_previous = [
                        "Shift+ISO_Left_Tab"
                        "Ctrl+k"
                    ];
                };

                brightness = {
                    enable_ddcutil = true;
                    monitor = {
                        "${monitorThinkpad}" = {
                            backend = "backlight";
                            backlight_device = "intel_backlight";
                        };

                        "${monitorSamsung}" = {
                            backend = "ddcutil";
                        };
                    };
                };

                osd = {
                    background_opacity = 0.98;
                    border = true;
                    enabled = true;
                    monitors = [
                        monitorSamsung
                    ];
                    orientation = "horizontal";
                    position = "top_center";
                    position_vertical = "top_center";
                    kinds = {
                        media = false;
                    };
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
