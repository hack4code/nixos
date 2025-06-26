{
    services = {
        dnscrypt-proxy2 = {
            enable = true;
            settings = {
                listen_addresses = [ "[::1]:53" "127.0.0.1:53" ];
                # server_names = [ "linode" ];
                static.linode.stamp = "sdns://AQcAAAAAAAAAFDE3Mi4yMzYuMjE5LjI1Mzo2NjY2IIXgg3kWnVLB-lsua8Ker3nNRsHLepRxeKVRF8NZjvjAHzIuZG5zY3J5cHQtY2VydC5kbnNjcnlwdC5saW5vZGU";

                netprobe_address = "8.8.8.8:53";
                bootstrap_resolvers = [ "8.8.8.8:53" ];
                require_dnssec = true;
                use_syslog = true;
                ignore_system_dns = true;

                sources.public-resolvers = {
                    urls = [
                        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                    ];
                    cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
                    minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
