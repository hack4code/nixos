{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.lazygit = {
            enable = true;

            settings = {
                gui = {
                    theme = {
                        activeBorderColor = [
                            "green"
                            "bold"
                        ];
                        inactiveBorderColor = [
                            "black"
                        ];
                        selectedLineBgColor = [
                            "black"
                        ];
                        defaultFgColor = [
                            "default"
                        ];
                    };
                    mouseEvents = false;
                    language = "en";
                    border = "rounded";
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
