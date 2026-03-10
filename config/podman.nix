{ lib, ... }:

{
    options = with lib; with types; {
        podmanNetworkName = mkOption { type = str; };
    };

    config = {
        podmanNetworkName = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
