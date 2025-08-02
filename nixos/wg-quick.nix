{ config, pkgs, ... }:

let
    interface = config.wifiInterface;
    wgInterface = config.wgInterface;
    wgListenPort = config.wgListenPort;
    wgIp4Address = config.wgIp4Address;
    wgIp6Address = config.wgIp6Address;
    wgPrivateKey = config.wgPrivateKey;
    wgServerPubkey = config.wgServerPubkey;
    wgPresharedKey = config.wgPresharedKey;
    serverIp4Address = config.serverIp4Address;
    serverIp6Address = config.serverIp6Address;
    wgServerIp4Address = config.wgServerIp4Address;
    wgServerIp6Address = config.wgServerIp6Address;
    wgServerPort = builtins.toString config.wgServerPort;
    dnsPort = builtins.toString config.dnsPort;
in
{
    networking.wg-quick.interfaces = {
        ${wgInterface} = {
            address = [
                wgIp4Address
                wgIp6Address
            ];
            privateKey = wgPrivateKey;
            listenPort = wgListenPort;
            mtu = 1408;

            postUp = ''
                ${pkgs.ethtool}/bin/ethtool -K ${interface} rx-gro-list off
                ${pkgs.ethtool}/bin/ethtool -K ${interface} rx-udp-gro-forwarding on
                ${pkgs.iproute2}/bin/tc qdisc add dev ${wgInterface} root fq_codel
                sysctl -q net.ipv4.conf.${wgInterface}.route_localnet=1
                ${pkgs.nftables}/bin/nft -f /etc/wireguard/wireguard.nft
            '';

            preDown = ''
                ${pkgs.nftables}/bin/nft delete table ip dnscrypt-proxy
                ${pkgs.nftables}/bin/nft delete table ip6 dnscrypt-proxy
            '';

            peers = [
                {
                    endpoint = "[${serverIp6Address}]:${wgServerPort}";
                    publicKey = wgServerPubkey;
                    presharedKey = wgPresharedKey;

                    allowedIPs = [
                        "0.0.0.0/0"
                        "::/0"
                    ];
                    persistentKeepalive = 480;
                }
            ];
        };
    };

    environment.etc."wireguard/wireguard.nft" = {
        text = ''
            table ip dnscrypt-proxy {
                chain input {
                    type filter hook input priority filter; policy accept;
                    iifname "${wgInterface}" ip saddr ${wgServerIp4Address} udp sport ${dnsPort} ip saddr set ${serverIp4Address}
                }
            }

            table ip6 dnscrypt-proxy {
                chain input {
                    type filter hook input priority filter; policy accept;
                    iifname "${wgInterface}" ip6 saddr ${wgServerIp6Address} udp sport ${dnsPort} ip6 saddr set ${serverIp6Address}
                }
            }

            table ip rpcdaemon {
                chain prerouting {
                    type nat hook prerouting priority dstnat; policy accept;
                    iifname "${wgInterface}" ip saddr ${wgServerIp4Address} tcp dport 8080 dnat to 127.0.0.1
                }
            }
        '';

        mode = "0660";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
