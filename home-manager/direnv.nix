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


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
