{ lib, ... }:

{
    options = with lib; with types; {
        sonyID = mkOption { type = str; };
    };

    config = {
        sonyID = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
