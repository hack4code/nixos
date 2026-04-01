{ config, pkgs, ... }:

let
    userName = config.userName;
    colorBackground = config.colorBackground;
    colorBackground1 = config.colorBackground1;
    colorBackground2 = config.colorBackground2;
    colorAqua = config.colorAqua;
    colorGreen = config.colorGreen;
    colorYellow = config.colorYellow;
    colorRed = config.colorRed;
    colorBlue = config.colorBlue;
    colorOrange = config.colorOrange;
in
{
    home-manager.users.${userName} = {
        programs.sherlock = {
            enable = true;

            systemd = {
                enable = false;
            };

            ignore = ''
                NetHack
                wl-kbptr
                Avahi*
                qt*
                userfeedback*
                Keyboard*
                Fcitx 5
                Fcitx 5 Migration*
                Neovim*
                NixOS Manual
            '';

            aliases = {
                "Volume Control" = {
                    icon = "pavucontrol";
                };

                ranger = {
                    icon = "file-manager";
                };
            };

            launchers =
            let
                noctalia-ipc = "noctalia-shell ipc call";
                cliphist = "${pkgs.cliphist}/bin/cliphist";
            in
            [
                {
                    name = "App Launcher";
                    alias = "app";
                    type = "app_launcher";
                    args = {};
                    priority = 1;
                    home = "Home";
                }

                {
                    name = "Sound Volume";
                    type = "command";
                    args = {
                        commands = {
                            s8 = {
                                icon = "audio-volume-high";
                                exec = "bash -c '${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%'";
                                search_string = "s8";
                            };

                            s6 = {
                                icon = "audio-volume-low";
                                exec = "bash -c '${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 60%'";
                                search_string = "s6";
                            };
                        };
                    };
                    priority = 2;
                    home = "Home";
                }

                {
                    name = "Mpd";
                    type = "command";
                    args = {
                        commands = {
                            "Next Song" = {
                                icon = "juk";
                                exec = "bash -c '${pkgs.mpc}/bin/mpc next'";
                                search_string = "next";
                            };

                            "Sound Volume 32" = {
                                icon = "juk";
                                exec = "bash -c '${pkgs.mpc}/bin/mpc volume 32'";
                                search_string = "32";
                            };

                            "Sound Volume 48" = {
                                icon = "juk";
                                exec = "bash -c '${pkgs.mpc}/bin/mpc volume 48'";
                                search_string = "48";
                            };
                        };
                    };
                    priority = 3;
                    home = "Home";
                }

                {
                    name = "syncdrive";
                    type = "command";
                    args = {
                        commands = {
                            SyncDrive = {
                                icon = "google-drive";
                                exec = "bash -c syncdrive.sh";
                                search_string = "syncdrive";
                            };
                        };
                    };
                    priority = 8;
                    home = "Home";
                }

                {
                    name = "downmovie";
                    type = "command";
                    args = {
                        commands = {
                            DownMovie = {
                                icon = "media-downloader";
                                exec = "bash -c downmovie.sh";
                                search_string = "downmovie";
                            };
                        };
                    };
                    priority = 9;
                    home = "Home";
                }

                {
                    name = "Noctalia Shell";
                    type = "command";
                    args = {
                        commands = {
                            "Control Center" = {
                                icon = "preferences";
                                exec = "bash -c '${noctalia-ipc} controlCenter open'";
                                search_string = "controlCenter";
                            };

                            "Settings" = {
                                icon = "gnome-settings";
                                exec = "bash -c '${noctalia-ipc} settings open'";
                                search_string = "setting";
                            };

                            "Windows" = {
                                icon = "preferences-system-windows-move";
                                exec = "bash -c '${noctalia-ipc} launcher windows'";
                                search_string = "window";
                            };

                            "Notification Enable DND" = {
                                icon = "notification-active";
                                exec = "bash -c '${noctalia-ipc} notifications enableDND'";
                                search_string = "dnd";
                            };

                            "Notification Disable DND" = {
                                icon = "notification-disabled";
                                exec = "bash -c '${noctalia-ipc} notifications disableDND'";
                                search_string = "dnd";
                            };

                            "Notification Clear All" = {
                                icon = "notifyconf";
                                exec = "bash -c '${noctalia-ipc} notifications clear'";
                                search_string = "notification";
                            };

                            "Clipboard Clear All" = {
                                icon = "xclipboard";
                                exec = "bash -c '${cliphist} wipe'";
                                search_string = "clip";
                            };
                        };
                    };
                    priority = 10;
                    home = "Home";
                }
            ];

            settings = {
                default_apps = {
                    terminal = "kitty";
                    browser = "firefox --new-tab %u";
                };

                search_bar_icon = {
                    enable = true;
                    icon = "searchmonkey";
                    size = 20;
                };

                status_bar = {
                    enable = false;
                };

                runtime = {
                    center = true;
                    daemonize = true;
                };

                binds = {
                    up = "control-p";
                    down = "control-n";
                    left = "control-h";
                    right = "control-l";
                    context = "control-i";
                    modifier = "alt";
                };

                caching = {
                    enable = true;
                    cache = "~/.cache/sherlock/cache.json";
                };

                behavior = {
                    use_xdg_data_dir_icons = false;
                    animate = true;
                };

                appearance = {
                    width = 400;
                    height = 600;
                    icon_size = 24;
                    use_base_css = true;
                    gsk_renderer = "vulkan";
                    opacity = 1.0;
                    icon_paths = [
                        "${pkgs.candy-icons}/share/icons/candy-icons"
                        "${pkgs.adwaita-icon-theme}/share/icons/Adwaita"

                    ];
                    mod_key_ascii = [
                        "⇧"
                        "⇧"
                        "⌘"
                        "⌘"
                        "⎇"
                        "✦"
                        "✦"
                        "⌘"
                    ];
                };

                files = {
                    css = "~/.config/sherlock/themes/gruvbox.css";
                };

                backdrop = {
                    enable = false;
                    opacity = 0.9;
                    edge = "top";
                };
            };
        };

        home.file.".config/sherlock/themes/gruvbox.css" = {
            executable = false;
            force = true;
            text = ''
                :root {
                    --foreground: ${colorBackground2};
                    --button-background: ${colorBackground1};
                    --background: ${colorBackground};
                    --border: ${colorBlue};
                    --text: ${colorGreen};
                    --text-button: ${colorOrange};
                    --text-selected: ${colorAqua};
                    --launcher-type: ${colorYellow};
                    --status-label: ${colorRed};
                }

                window {
                    border-radius: 12px;
                    border: 1px solid var(--border);
                    background: var(--background);
                }

                label {
                    font-family: Roboto Flex;
                    color: var(--text);
                }

                #overlay spinner {
                    color: var(--text);
                }

                #launcher-type {
                    font-size: 10px;
                    font-weight: 400;
                    color: var(--launcher-type);
                    margin-left: 0px;
                }

                #shortcut-holder {
                    background: var(--button-background);
                    margin-right: 25px;
                    padding: 5px 10px;
                    border-radius: 6px;
                    border: 1px solid hsl(from var(--border) h s l / 10%);
                    box-shadow: 0px 0px 6px 0px rgba(15, 15, 15, 1);
                }

                #search-bar {
                    outline: none;
                    border: none;
                    background: var(--background);
                    min-height: 40px;
                    color: var(--text);
                    font-size: 16px;
                    font-weight: 400;
                    padding-left: 20px;
                }

                #search-bar-holder {
                    border-bottom: 1px solid var(--border);
                    padding: 5px 10px 4px 10px;
                }

                #search-icon-holder image {
                    transition: 0.1s ease;
                }

                #search-icon {
                    margin-left: 10px;
                }

                #search-bar placeholder {
                    background: transparent;
                    color: hsl(from var(--text) h s l / 30%);
                    font-weight: 500;
                }

                #category-type {
                    font-size: 13px;
                    font-weight: bold;
                    color: var(--text);
                    padding: 10px 20px 0px 20px;
                }

                scrollbar {
                }

                image {
                    color: white;
                }

                .tile {
                    outline: none;
                    min-height: 50px;
                    padding: 0px 10px;
                    margin-bottom: 5px;
                    border: 1px solid transparent;
                    border-radius: 4px;
                }

                .tile #title {
                    font-size: 15px;
                    color: var(--text);
                }

                .tile #icon {
                    margin: 0px;
                    padding: 0px;
                }

                #color-icon-holder {
                    border-radius: 50px;
                }

                #shortcut-holder {
                    margin-right: 16px;
                    padding: 5px 10px;
                    background: var(--button-background);
                    border-radius: 5px;
                    border: 1px solid var(--border);
                    box-shadow: 0px 0px 6px 0px rgba(15, 15, 15, 1);
                }

                #shortcut,
                #shortcut-modkey {
                    background: transparent;
                    font-weight: bold;
                    color: var(--text-button);
                    font-size: 12px;
                }

                .status-bar {
                    background: var(--background);
                    border-top: 1px solid var(--border);
                    padding: 4px 10px 4px 20px;
                }

                .status-bar label {
                    color: var(--status-label);
                }

                .status-bar #shortcut-key,
                .status-bar #shortcut-modifier {
                    background: var(--button-background);
                    margin: 2px;
                    padding: 1px 5px;
                    border-radius: 3px;
                    font-size: 12px;
                }

                .status-bar #shortcut-description {
                    font-size: 12px;
                    margin-right: 10px;
                }

                #context-menu {
                    min-width: 50px;
                    padding: 5px;
                    margin: 4px;
                    background: var(--background);
                    border: 1px solid var(--border);
                    border-radius: 5px;
                }

                #context-menu row {
                    color: var(--text);
                    transition: 0.1s ease;
                    padding: 10px 20px;
                    border-radius: 5px;
                }

                #context-menu label {
                    color: var(--text-button);
                    font-size: 13px;
                }

                row:selected #title {
                    color: var(--text-selected);
                    font-weight: 500;
                }

                #context-menu row:selected {
                    color: var(--text-selected);
                }

                .tile:selected #shortcut-holder {
                    box-shadow: 0px 0px 6px 0px rgba(22, 22, 22, 1);
                }

            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
