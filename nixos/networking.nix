{
    systemd.network.wait-online.enable = true;

    networking = {
        hostName = "KISS";
        enableIPv6 = true;
        nameservers = [ "127.0.0.1" "::1" ];

        firewall = {
          enable = false;
        };

        wireless.dbusControlled = true;

        networkmanager = {
            enable = true;
            dns = "none";
            wifi.backend = "iwd";

            connectionConfig = {
                autoconnect = true;
                autoconnect-priority = 999;
                interface-name = "wlan0";
                type = "802-11-wireless";
                wait-device-timeout = 32;
                id = "wireless";
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
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
