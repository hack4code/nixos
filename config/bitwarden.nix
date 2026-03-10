{ lib, ... }:

{
    options = with lib; with types; {
        bwSession = mkOption { type = str; };
    };

    config = {
        bwSession = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
