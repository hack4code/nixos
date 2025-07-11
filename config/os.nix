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
        kernelVersion = "6.15.6";
        kernelSha256 = "2bb586c954277d070c8fdf6d7275faa93b4807d9bf3353b491d8149cca02b4fc";
        hostName = "KISS";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
