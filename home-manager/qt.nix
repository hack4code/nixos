{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        qt = {
            enable = true;
            platformTheme = {
                name = "adwaita";
            };
            style = {
                name = "adwaita-highcontrast";
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
