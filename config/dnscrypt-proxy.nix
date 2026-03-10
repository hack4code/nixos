{ lib, ... }:

{
    options = with lib; with types; {
        dnsServerName = mkOption { type = str; };
        dnsStamp = mkOption { type = str; };
    };

    config = {
        dnsServerName = "";
        dnsStamp = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
