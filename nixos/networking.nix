{ config, ... }:

let
    hostName = config.hostName;
    wifiSSID = config.wifiSSID;
    wifiUUID = config.wifiUUID;
    wifiInterface = config.wifiInterface;
    wifiPassWord = config.wifiPassWord;
    ntpServers = config.ntpServers;
    wgListenPort = config.wgListenPort;
    wgInterface = config.wgInterface;
in
{
    systemd.services.NetworkManager-wait-online.environment = {
        NM_ONLINE_TIMEOUT = "180";
    };

    networking = {
        useDHCP = false;

        hostName = hostName;

        dhcpcd = {
            enable = false;
        };

        nameservers = [
            "::1"
            "127.0.0.1"
        ];

        wireless = {
            dbusControlled = true;
        };

        nftables = {
            enable = true;
        };

        firewall = {
            enable = true;
            trustedInterfaces = [
                wgInterface
            ];
            allowedUDPPorts = [
                wgListenPort
            ];
        };

        networkmanager = {
            enable = true;
            dns = "none";

            wifi = {
                backend = "iwd";
                powersave = false;
                macAddress = "random";
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
                    wait-device-timeout = 300000;
                    wait-activation-delay = 300000;
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
