{ lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
        hostName = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.05";
        kernelVersion = "6.15.7";
        kernelSha256 = "3507dd105b0a0e1101bd43d294472fccf853429a259a5fa7c67467bba318f8e9";
        hostName = "KISS";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
