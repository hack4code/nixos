{ config, pkgs, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        xdg = {
            portal = {
                enable = true;
                config = {
                    sway = {
                        default = [
                            "gtk"
                        ];

                        # "org.freedesktop.impl.portal.FileChooser" = [
                        #     "termfilechooser"
                        # ];

                        "org.freedesktop.impl.portal.Screenshot" = [
                            "wlr"
                        ];

                        "org.freedesktop.impl.portal.ScreenCast" = [
                            "wlr"
                        ];

                        "org.freedesktop.impl.portal.Inhibit" = [
                            "none"
                        ];
                    };
                };
                extraPortals = with pkgs; [
                    xdg-desktop-portal-wlr
                    xdg-desktop-portal-gtk
                    # xdg-desktop-portal-termfilechooser
                ];
            };
        };

        # home.sessionVariables.TERMCMD = "kitty --class=file_chooser";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
