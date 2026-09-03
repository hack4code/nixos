{ lib, ... }:

{
    options = with lib; with types; {
        nfsMountdPort = mkOption { type = int; };
    };

    config = {
        nfsMountdPort = 3333;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
