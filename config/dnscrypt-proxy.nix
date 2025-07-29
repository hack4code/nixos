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


# vim: ts=4 sw=4 sts=4 ft=nix et:
