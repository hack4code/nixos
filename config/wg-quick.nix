{ lib, ... }:

{
    options = with lib; with types; {
        ip4AddressOfRule = mkOption { type = listOf str; };
        ip6AddressOfRule = mkOption { type = listOf str; };
    };

    config = {
        ip4AddressOfRule = [ ];
        ip6AddressOfRule = [ ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
