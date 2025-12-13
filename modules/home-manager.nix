{ config, ... }:

let
    userName = config.userName;
    homeManagerVersion = config.homeManagerVersion;
in
{
    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        users = {
            ${userName} = {
                home = {
                    enableNixpkgsReleaseCheck = false;
                    stateVersion = homeManagerVersion;
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
