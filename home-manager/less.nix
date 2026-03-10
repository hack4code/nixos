{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs = {
            less = {
                enable = true;

                config = ''
                    #command
                    s    back-line
                    t    forw-line
                '';

                options = {
                    RAW-CONTROL-CHARS = true;
                    quiet = true;
                    wheel-lines = 3;
                };
            };

            lesspipe = {
                enable = true;
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
