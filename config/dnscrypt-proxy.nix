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
        dnsServerList = [
            "cloudflare"
            "cloudflare-ipv6"
            "a-and-a"
            "a-and-a-ipv6"
            "google"
            "google-ipv6"
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
