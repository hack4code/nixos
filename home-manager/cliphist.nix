{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        services.cliphist = {
            enable = true;

            allowImages = true;

            extraOptions = [
                "-max-dedupe-search"
                "10"
                "-max-items"
                "500"
            ];

            systemdTargets = [
                "sway-session.target"
            ];
        };

    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
