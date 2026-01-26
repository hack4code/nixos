{ config, pkgs, ... }:

let
    userName = config.userName;
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

            launchers = [
                {
                    name = "App Launcher";
                    alias = "app";
                    type = "app_launcher";
                    args = {};
                    priority = 1;
                    home = "Home";
                }

                {
                    name = "Sound Volume Control";
                    alias = "snd";
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
                    name = "Mpc Command";
                    alias = "mpc";
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
                    name = "supertux2";
                    alias = "supertux2";
                    type = "command";
                    args = {
                        tux = {
                            icon = "supertux";
                            exec = "${pkgs.superTux}/bin/supertux2";
                            search_string = "supertux2";
                        };
                    };
                    priority = 4;
                    home = "Home";
                }

                {
                    name = "pcsx2";
                    alias = "pcsx2";
                    type = "command";
                    args = {
                        tux = {
                            icon = "pcsx2";
                            exec = "${pkgs.pcsx2}/bin/pcsx2-qt";
                            search_string = "pcsx2";
                        };
                    };
                    priority = 5;
                    home = "Home";
                }

                # {
                #     name = "mame";
                #     alias = "mame";
                #     type = "command";
                #     args = {
                #         mame = {
                #             icon = "mame";
                #             exec = "${pkgs.mame}/bin/mame";
                #             search_string = "mame";
                #         };
                #     };
                #     priority = 6;
                #     home = "Home";
                # }

                {
                    name = "rpcs3";
                    alias = "rpcs3";
                    type = "command";
                    args = {
                        rpcs3 = {
                            icon = "rpcs3";
                            exec = "${pkgs.rpcs3}/bin/rpcs3";
                            search_string = "rpcs3";
                        };
                    };
                    priority = 7;
                    home = "Home";
                }

                {
                    name = "syncdrive";
                    alias = "syncdrive";
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
                    alias = "downmovie";
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
                    name = "Kill Process";
                    alias = "kill";
                    type = "process";
                    args = {};
                    priority = 0;
                }

                {
                    name = "Web Search";
                    display_name = "Google";
                    tag_start = "{keyword}";
                    alias = "gg";
                    type = "web_launcher";
                    args = {
                        search_engine = "google";
                        icon = "searchmonkey";
                    };
                    priority = 100;
                    home = "Home";
                }
            ];

            settings = {
                default_apps = {
                    terminal = "kitty";
                    browser = "firefox --new-tab %u";
                };

                search_bar_icon = {
                    enable = false;
                };

                binds = {
                    up = "control-p";
                    down = "control-n";
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
                    width = 320;
                    height = 600;
                    gsk_renderer = "vulkan";
                    opacity = 0.98;
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

                backdrop = {
                    enable = false;
                    opacity = 0.9;
                    edge = "top";
                };
            };

            style = ''
                * {
                    font-family: Roboto Flex;
                }
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
