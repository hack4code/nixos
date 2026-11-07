{ lib, ... }:

{
    options = with lib; with types; {
        socks5Proxy = mkOption { type = str; };
        torProxy = mkOption { type = str; };
    };

    config = {
        socks5Proxy = "";
        torProxy = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
