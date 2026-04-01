{ lib, stable, ... }:

{
    options = with lib; with types; {
        hostName = mkOption { type = str; };
        timeZone = mkOption { type = str; };
        nixOSVersion = mkOption { type = str; };
    };

    config = {
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
        nixOSVersion = if stable then "25.11" else "26.05";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
