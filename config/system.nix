{ lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        homeManagerVersion = mkOption { type = str; };
        hostName = mkOption { type = str; };
        timeZone = mkOption { type = str; };
    };

    config = {
        nixosVersion = "26.05";
        homeManagerVersion = "25.11";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
