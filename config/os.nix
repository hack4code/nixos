{ config, pkgs, lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
        hostName = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.05";
        kernelVersion = "6.15.5";
        kernelSha256 = "2ca707939c14431232649874d438aa58f11b4b127290fa68d164f8bd79c688b5";
        hostName = "KISS";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
