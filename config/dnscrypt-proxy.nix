{ lib, ... }:

{
    options = with lib; with types; {
        dnsServerName = mkOption { type = str; };
        dnsStamp = mkOption { type = str; };
        dnsServerList = mkOption { type = listOf str; };
    };

    config = {
        dnsServerName = "";
        dnsStamp = "";
        dnsServerList = [ ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
