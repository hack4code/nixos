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
        vpsV6Range = mkOption { type = str; };
        vpsIp4Address = mkOption { type = str; };
        vpsIp6Address = mkOption { type = str; };
        wgMTU = mkOption { type = int; };
        wgEndPoint = mkOption { type = str; };

        dnsPort = mkOption { type = port; };
    };

    config = rec {
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
        wgMTU = 1200;
        # wgEndPoint = "${vpsIp4Address}:" + builtins.toString wgServerPort;
        # wgEndPoint = "[${vpsIp6Address}]:" + builtins.toString wgServerPort;
        wgEndPoint = "[${wgServerIp6Address}]:" + builtins.toString wgServerPort;

        vpsV6Range = "";
        vpsIp4Address = "";
        vpsIp6Address = "";

        dnsPort = 0;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
