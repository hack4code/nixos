{
    networking = {
        hostName = "KISS";
        enableIPv6 = true;
        nameservers = [ "127.0.0.1" "::1" ];

        firewall = {
          enable = false;
        };

        networkmanager = {
            enable = true;
            dns = "none";
            wifi.backend = "iwd";

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
