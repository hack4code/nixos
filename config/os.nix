{ config, pkgs, lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.05";
        kernelVersion = "6.15.3";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
