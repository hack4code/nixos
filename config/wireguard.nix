{ lib, ... }:

{
    options = with lib; with types; {
        wgInterface = mkOption { type = str; };
        wgListenPort = mkOption { type = port; };
        wgServerPort = mkOption { type = port; };
        wgIp4Address = mkOption { type = str; };
        wgIp6Address = mkOption { type = str; };
        wgPrivateKey = mkOption { type = str; };
        wgServerPubkey = mkOption { type = str; };
        wgPresharedKey = mkOption { type = str; };
        wgServer = mkOption { type = str; };
        wgServerIp4Address = mkOption { type = str; };
        wgServerIp6Address = mkOption { type = str; };
        serverIp4Address = mkOption { type = str; };
        serverIp6Address = mkOption { type = str; };

        dnsPort = mkOption { type = port; };
    };

    config = {
        wgInterface = "";
        wgListenPort = 0;
        wgIp4Address = "";
        wgIp6Address = "";
        wgPrivateKey = "";
        wgServerPubkey = "";
        wgPresharedKey = "";
        wgServerIp4Address = "";
        wgServerIp6Address = "";
        wgServerPort = 0;

        serverIp4Address = "";
        serverIp6Address = "";
        dnsPort = 0;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
