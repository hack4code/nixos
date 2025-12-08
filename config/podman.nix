{ lib, ... }:

{
    options = with lib; with types; {
        podmanNetworkName = mkOption { type = str; };
    };

    config = {
        podmanNetworkName = "";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
