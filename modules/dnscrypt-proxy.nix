{ config, ... }:

let
    dnsServerName = config.dnsServerName;
    dnsStamp = config.dnsStamp;
in
{
    systemd.services.dnscrypt-proxy = {
        after = [
            "wg-quick-wg0.service"
        ];
    };

    services = {
        dnscrypt-proxy = {
            enable = true;
            settings = {
                listen_addresses = [
                    "[::1]:53"
                    "127.0.0.1:53"
                ];
                netprobe_timeout = -1;
                netprobe_address = "1.1.1.1:53";
                bootstrap_resolvers = [
                    "8.8.8.8:53"
                    "1.1.1.1:53"
                ];
                require_dnssec = true;
                use_syslog = true;
                ignore_system_dns = true;
                sources = {
                    public-resolvers = {
                        urls = [
                            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                        ];
                        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
                        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
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


# vim: ts=4 sw=4 sts=4 ft=nix et:
