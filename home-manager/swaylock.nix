{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.swaylock = {

            enable = true;

            settings = {
                show-failed-attempts = true;
                disable-caps-lock-text = true;

                image = "~/.config/swaylock/evolution.jpg";
                scaling = "fit";

                indicator-radius = 60;
                indicator-thickness = 6;
                indicator-caps-lock = true;

                color = "000000";
                ring-color = "1f1f28";
                ring-clear-color = "ffa066";
                ring-caps-lock-color = "1f1f28";
                ring-ver-color = "98bb6c";
                ring-wrong-color = "1f1f28";
                separator-color = "00ff00";
            };
        };

        home.file.".config/swaylock" = {
            source = ../swaylock;
            recursive = true;
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
