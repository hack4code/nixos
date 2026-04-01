{ config, pkgs, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
in
{
    home-manager.users.${userName} = {
        xdg = {
            enable = true;

            cacheHome = "${userHome}/.cache";
            configHome = "${userHome}/.config";
            dataHome = "${userHome}/.local/share";
            stateHome = "${userHome}/.local/state";

            userDirs = {
                enable = true;
                createDirectories = false;
                desktop = "${userHome}/temp";
                documents = "${userHome}/document";
                download = "${userHome}/download";
                music = "${userHome}/music";
                pictures = "${userHome}/picture";
                publicShare = "${userHome}/temp";
                templates = "${userHome}/temp";
                videos = "${userHome}/movie";
            };

            portal = {
                enable = true;

                config = {
                    sway = {
                        default = [
                            "gtk"
                        ];

                        "org.freedesktop.impl.portal.Screenshot" = [
                            "wlr"
                        ];

                        "org.freedesktop.impl.portal.ScreenCast" = [
                            "wlr"
                        ];

                        "org.freedesktop.impl.portal.Inhibit" = [
                            "none"
                        ];

                        "org.freedesktop.impl.portal.FileChooser" = [
                            "termfilechooser"
                        ];
                    };
                };

                extraPortals = with pkgs; [
                    xdg-desktop-portal-wlr
                    xdg-desktop-portal-gtk
                    xdg-desktop-portal-termfilechooser
                ];
            };

            configFile."xdg-desktop-portal-termfilechooser/config" = {
                force = true;
                executable = false;
                text = ''
                    [filechooser]
                    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh
                    default_dir=$HOME/book/
                    env=PATH=/run/current-system/sw/bin/:$PATH:
                        TERMCMD="kitty --title termfilechooser --class file_chooser --override font_family=Iosevka --override font_size=13 --override modify_font='cell_height +16px'"
                    open_mode=suggested
                    save_mode=last
                '';
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
