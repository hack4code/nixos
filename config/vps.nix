{ lib, ... }:

{
    options = with lib; with types; {
        vpsName = mkOption { type = str; };
    };

    config = {
        vpsName = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
