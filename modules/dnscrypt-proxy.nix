{ config, ... }:

let
    dnsServerName = config.dnsServerName;
    dnsStamp = config.dnsStamp;
in
{
    systemd.services.dnscrypt-proxy = {
        wants = [
            "iwd.service"
            "network-online.target"
        ];

        after = [
            "iwd.service"
            "network-online.target"
        ];
    };

    environment.etc."dnscrypt-proxy/cloaking-rules.txt" = {
        text = ''
            *.linode.me  10.0.0.1
        '';

        mode = "0666";
    };

    services = {
        dnscrypt-proxy = {
            enable = true;
            settings = {
                listen_addresses = [
                    "[::1]:53"
                    "127.0.0.1:53"
                ];

                netprobe_address = "9.9.9.9:53";

                bootstrap_resolvers = [
                    "1.1.1.1:53"
                    "8.8.8.8:53"
                ];

                netprobe_timeout = 180;

                require_dnssec = true;
                use_syslog = true;
                ignore_system_dns = true;

                cache = true;
                cache_size = 8192;
                cache_min_ttl = 4800;
                cache_max_ttl = 172800;
                cache_neg_min_ttl = 60;
                cache_neg_max_ttl = 600;


                cloaking_rules = "/etc/dnscrypt-proxy/cloaking-rules.txt";

                sources = {
                    public-resolvers = {
                        urls = [
                            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                        ];
                        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
                        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
                        refresh_delay = 73;
                    };
                };

                static = {
                    "${dnsServerName}" = {
                        stamp = "${dnsStamp}";
                    };
                };

                server_names = [ dnsServerName ];
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
