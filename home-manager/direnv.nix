{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.direnv = {
            enable = true;

            # silent = true;
            enableZshIntegration = true;

            nix-direnv = {
                enable = true;
            };

            config = {
                warn_timeout = 0;
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
