{ config, lib, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
in
{
    home-manager.users.${userName} = {
        programs.starship = {
            enable = true;

            configPath = "${userHome}/.config/starship/starship.toml";
            settings = {
                add_newline = false;
                format = lib.concatStrings [
                    "$line_break"
                    "$package"
                    "$line_break"
                    "$character"
                ];
                scan_timeout = 10;
                character = {
                    success_symbol = "➜";
                    error_symbol = "➜";
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
