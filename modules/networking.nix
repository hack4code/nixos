{ config, pkgs, ... }:

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
        NM_ONLINE_TIMEOUT = "240";
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
            backend = "nftables";
            allowPing = false;
            checkReversePath = true;
            extraPackages = [
                pkgs.ipset
            ];
            interfaces = {
                "${wifiInterface}" = {
                    allowedUDPPorts = [
                        # wiregurad
                        wgListenPort
                    ];
                };
                "${wgInterface}" = {
                    allowedTCPPorts = [
                        # NFS
                        2049
                        # rpcd
                        8080
                        # rtorrent
                        50000
                    ];
                    allowedUDPPorts = [
                        # NFS
                        2049
                        # rtorrent
                        50000
                    ];
                };
            };
        };

        networkmanager = {
            enable = true;

            dns = "none";
            unmanaged = [
                wgInterface
            ];

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
                    auth-retries = 5;
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
                    method = "auto";
                    addr-gen-mode = "default";
                };
            };
        };

        timeServers = ntpServers;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
