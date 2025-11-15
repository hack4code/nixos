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


# vim: ts=4 sw=4 sts=4 ft=nix et:
