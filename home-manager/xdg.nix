{ config, pkgs, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
in
{
    home-manager.users.${userName} = {
        home.file.".config/systemd/user/xdg-desktop-portal.service" = {
            executable = false;
            force = true;
            text = ''
                [Unit]
                Description=Portal service
                PartOf=
                Requisite=
                After=

                [Service]
                Type=dbus
                BusName=org.freedesktop.portal.Desktop
                ExecStart=${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal
                Slice=session.slice
            '';
        };

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

                xdgOpenUsePortal = true;

                config = {
                    sway = {
                        default = [
                            "gtk"
                        ];

                        "org.freedesktop.impl.portal.Inhibit" = [
                            "none"
                        ];

                        "org.freedesktop.impl.portal.FileChooser" = [
                            "termfilechooser"
                        ];

                        "org.freedesktop.impl.portal.Secret" = [
                            "gnome-keyring"
                        ];

                        "org.freedesktop.impl.portal.Screencast" = [
                            "wlr"
                        ];

                        "org.freedesktop.impl.portal.Screenshot" = [
                            "wlr"
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
                    env=PATH=/run/current-system/sw/bin/:$PATH:
                        TERMCMD="kitty --title termfilechooser --class file_chooser --override font_size=13 --override font_family='IosevkaTerm Nerd Font' --override modify_font='cell_height +16px' "
                    default_dir=$HOME/book/
                    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
                '';
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
