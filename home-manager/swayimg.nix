{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.swayimg = {
            enable = true;

            settings = {
                general = {
                    size = "800,600";
                    overlay = "yes";
                };

                info = {
                    show = "no";
                };

                viewer = {
                    window = "#00000000";
                    scale = "optimal";
                };

                font = {
                    name = "Roboto Flex";
                    size = 12;
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
