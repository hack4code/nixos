{ config, pkgs, ... }:

let
    wifiSSID = config.wifiSSID;
    wifiUUID = config.wifiUUID;
    wifiInterface = config.wifiInterface;
    wifiPassWord = config.wifiPassWord;
in
{
    networking = {
        hostName = "KISS";
        enableIPv6 = true;
        nameservers = [ "127.0.0.1" "::1" ];
        firewall.enable = false;
        wireless.dbusControlled = true;

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
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
