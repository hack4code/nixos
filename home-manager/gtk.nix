{ config, pkgs, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        gtk = {
            enable = true;
            colorScheme = "light";
            iconTheme = {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
            };
            font = {
                name = "Noto Sans";
                size = 10;
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
