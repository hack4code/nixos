{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        services.cliphist = {
            enable = true;

            allowImages = false;
            extraOptions = [
                "-max-dedupe-search"
                "32"
                "-max-items"
                "32"
            ];

            systemdTargets = [
                "sway-session.target"
            ];
        };

    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
