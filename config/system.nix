{ lib, ... }:

{
    options = with lib; with types; {
        hostName = mkOption { type = str; };
        timeZone = mkOption { type = str; };
    };

    config = {
        hostName = "";
        timeZone = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
