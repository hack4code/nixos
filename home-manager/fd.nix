{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.fd = {
            enable = true;

            hidden = false;

            extraOptions = [
            ];

            ignores = [
                ".git/"
                "*.bak"
                "*.backup"
            ];
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
