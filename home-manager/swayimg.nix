{ config, nixOSVersion, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.swayimg = {
            enable = true;
        } // (if nixOSVersion == "26.11" then {
            initLua = "
                swayimg.viewer.on_key(\"q\", function()
                    swayimg.exit()
                end)
            ";
        }
        else {
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
        });
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
