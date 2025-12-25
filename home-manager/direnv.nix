{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv = {
                enable = true;
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
