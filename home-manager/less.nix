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


# vim: ts=4 sw=4 sts=4 ft=nix et:
