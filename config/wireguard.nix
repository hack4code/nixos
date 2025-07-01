{ config, pkgs, lib, ... }:

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
        wgInterface = "wg0";
        wgListenPort = 8888;
        wgIp4Address = "10.0.0.2/32";
        wgIp6Address = "2a01:7e03:e001:dd::2/128";
        wgPrivateKey = "GLuwtODYFb6QGUnwTI5rE/BI8cuOiaNSzMo33xEx7HQ=";
        wgServerPubkey = "V5zSwusWV79IiBa309hLwpc3sl0GruDMuMwafT+CNQQ=";
        wgPresharedKey = "oCtVVRfCfAX7AKrsd2dAJAYVe117nAfymx/8EhHup+Q=";
        wgServerIp4Address = "10.0.0.1";
        wgServerIp6Address = "2a01:7e03:e001:dd::1";
        wgServerPort = 9999;

        serverIp4Address = "172.236.252.216";
        serverIp6Address = "2a01:7e03::2000:daff:fe68:e20e";
        dnsPort = 6666;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
