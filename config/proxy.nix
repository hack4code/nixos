{ lib, ... }:

{
    options = with lib; with types; {
        socks5Proxy = mkOption { type = str; };
    };

    config = {
        socks5Proxy = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
