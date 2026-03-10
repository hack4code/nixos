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


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
