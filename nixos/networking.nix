{ config, pkgs, ... }:

let
    hostName = config.hostName;
    wifiSSID = config.wifiSSID;
    wifiUUID = config.wifiUUID;
    wifiInterface = config.wifiInterface;
    wifiPassWord = config.wifiPassWord;
    ntpServers = config.ntpServers;
in
{
    networking = {
        hostName = hostName;
        useDHCP = false;
        dhcpcd.enable = false;
        nameservers = [ "127.0.0.1" "::1" ];
        wireless.dbusControlled = true;
        firewall.enable = false;

        networkmanager = {
            enable = true;
            dns = "none";
            wifi.backend = "iwd";
            wifi.powersave = true;

            connectionConfig = {
                "wifi.cloned-mac-address" = "preserve";
            };

            settings = {
                main = {
                    systemd-resolved = false;
                    firewall-backend = "nftables";
                };

                connectivity = {
                    uri = "http://connectivity-check.ubuntu.com";
                    interval = 720;
                };

                logging = {
                    level = "INFO";
                    domains = "ALL";
                    backend = "journal";
                };
            };

            ensureProfiles.profiles."${wifiSSID}" = {
                connection = {
                    id = wifiSSID;
                    uuid = wifiUUID;
                    interface-name = wifiInterface;
                    type = "wifi";
                    autoconnect = true;
                    permissions = "";
                    wait-device-timeout = 120000;
                    wait-activation-delay = 120000;
                };

                wifi = {
                    mode = "infrastructure";
                    ssid = wifiSSID;
                };

                wifi-security = {
                    auth-alg = "open";
                    key-mgmt = "wpa-psk";
                    psk = wifiPassWord;
                };

                ipv4 = {
                    method = "auto";
                };

                ipv6 = {
                    addr-gen-mode = "default";
                    method = "auto";
                };
            };
        };

        timeServers = ntpServers;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
