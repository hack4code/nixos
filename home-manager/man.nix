{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.man = {
            enable = false;
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
