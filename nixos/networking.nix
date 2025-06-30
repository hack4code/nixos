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
                    enable = false;
                    uri = "http://connectivity-check.ubuntu.com";
                    interval = 720;
                };

                logging = {
                    level = "INFO";
                    domains = "ALL";
                    backend = "journal";
                };
            };

            ensureProfiles.profiles."TP-LINK_1225" = {
                connection = {
                    id = "TP-LINK_1225";
                    uuid = "b4447384-06e8-4ef3-8689-f68589f1537c";
                    type = "wifi";
                    interface-name = "wlan0";
                    permissions = "";
                    wait-activation-delay = 180;
                    wait-device-timeout = 180;
                };

                wifi = {
                    mode = "infrastructure";
                    ssid = "TP-LINK_1225";
                };

                wifi-security = {
                    auth-alg = "open";
                    key-mgmt = "wpa-psk";
                    psk = "12345678";
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
