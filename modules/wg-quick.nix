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
    wgEndPoint = config.wgEndPoint;
    wgServerIp4Address = config.wgServerIp4Address;
    wgServerIp6Address = config.wgServerIp6Address;
    wgMTU = config.wgMTU;
    vpsIp4Address = config.vpsIp4Address;
    vpsIp6Address = config.vpsIp6Address;
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
            mtu = wgMTU;

            postUp = ''
                ${pkgs.ethtool}/bin/ethtool -K ${interface} rx-gro-list off
                ${pkgs.ethtool}/bin/ethtool -K ${interface} rx-udp-gro-forwarding on
                ${pkgs.iproute2}/bin/tc qdisc add dev ${wgInterface} root fq_codel
                ${pkgs.nftables}/bin/nft -f /etc/wireguard/wireguard.nft
                ${pkgs.procps}/bin/sysctl -q net.ipv4.conf.${wgInterface}.route_localnet=1
                # tuna
                ${pkgs.iproute2}/bin/ip rule add to 101.6.15.130/32 table main
                ${pkgs.iproute2}/bin/ip -6 rule add to 2402:f000:1:400::2/128 table main
                # sjtu
                ${pkgs.iproute2}/bin/ip rule add to 111.186.58.212/32 table main
                # ustc
                ${pkgs.iproute2}/bin/ip rule add to 202.38.95.110/32 table main
                ${pkgs.iproute2}/bin/ip -6 rule add to 2001:da8:d800:95::110/128 table main
            '';

            preDown = ''
                ${pkgs.nftables}/bin/nft delete table ip dnscrypt-proxy
                ${pkgs.nftables}/bin/nft delete table ip6 dnscrypt-proxy
                ${pkgs.nftables}/bin/nft delete table ip rpcdaemon
                # tuna
                ${pkgs.iproute2}/bin/ip rule delete to 101.6.15.130/32
                ${pkgs.iproute2}/bin/ip -6 rule delete to 2402:f000:1:400::2/128
                # sjtu
                ${pkgs.iproute2}/bin/ip rule delete to 111.186.58.212/32
                # ustc
                ${pkgs.iproute2}/bin/ip rule delete to 202.38.95.110
                ${pkgs.iproute2}/bin/ip -6 rule delete to 2001:da8:d800:95::110/128
            '';

            peers = [
                {
                    endpoint = wgEndPoint;
                    publicKey = wgServerPubkey;
                    presharedKey = wgPresharedKey;

                    allowedIPs = [
                        "0.0.0.0/0"
                        "::/0"
                    ];
                    persistentKeepalive = 360;
                }
            ];
        };
    };

    environment.etc."wireguard/wireguard.nft" = {
        text = ''
            table ip dnscrypt-proxy {
                chain input {
                    type filter hook input priority filter; policy accept;
                    iifname "${wgInterface}" ip saddr ${wgServerIp4Address} udp sport ${dnsPort} ip saddr set ${vpsIp4Address}
                }
            }

            table ip6 dnscrypt-proxy {
                chain input {
                    type filter hook input priority filter; policy accept;
                    iifname "${wgInterface}" ip6 saddr ${wgServerIp6Address} udp sport ${dnsPort} ip6 saddr set ${vpsIp6Address}
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
