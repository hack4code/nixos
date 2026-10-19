{ config, pkgs, lib, ... }:

let
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
    dnsPort = toString config.dnsPort;
    ip4AddressOfRule = config.ip4AddressOfRule;
    ip6AddressOfRule = config.ip6AddressOfRule;
in
{
    systemd.services."wg-quick-${wgInterface}" = {
        after = lib.mkForce [
            "network-online.target"
        ];
    };

    networking.wg-quick.interfaces = {
        ${wgInterface} = {
            address = [
                wgIp4Address
                wgIp6Address
            ];
            privateKey = wgPrivateKey;
            listenPort = wgListenPort;
            mtu = wgMTU;

            postUp =
            let
                postUp4IPv4 = lib.strings.concatStrings (lib.strings.intersperse ";" (map (v: "${pkgs.iproute2}/bin/ip -4 rule add to ${v}/32 table main") ip4AddressOfRule));
                postUp4IPv6 = lib.strings.concatStrings (lib.strings.intersperse ";" (map (v: "${pkgs.iproute2}/bin/ip -6 rule add to ${v}/128 table main") ip6AddressOfRule));
            in
            ''
                ${pkgs.iproute2}/bin/tc qdisc add dev ${wgInterface} root fq_codel
                ${pkgs.procps}/bin/sysctl -q net.ipv4.conf.${wgInterface}.route_localnet=1
                ${pkgs.nftables}/bin/nft -f /etc/wireguard/wireguard.nft
                ${postUp4IPv4};${postUp4IPv6};
            '';

            preDown =
            let
                preDownIPv4 = lib.strings.concatStrings (lib.strings.intersperse ";" (map (v: "${pkgs.iproute2}/bin/ip -4 rule delete to ${v}/32") ip4AddressOfRule));
                preDown4IPv6 = lib.strings.concatStrings (lib.strings.intersperse ";" (map (v: "${pkgs.iproute2}/bin/ip -6 rule delete to ${v}/128") ip6AddressOfRule));
            in
            ''
                ${pkgs.nftables}/bin/nft delete table ip rpcdaemon
                ${preDownIPv4};${preDown4IPv6};
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
            # table ip dnscrypt-proxy {
            #     chain input {
            #         type filter hook input priority filter; policy accept;
            #         iifname "${wgInterface}" ip saddr ${wgServerIp4Address} udp sport ${dnsPort} ip saddr set ${vpsIp4Address}
            #     }
            # }

            # table ip6 dnscrypt-proxy {
            #     chain input {
            #         type filter hook input priority filter; policy accept;
            #         iifname "${wgInterface}" ip6 saddr ${wgServerIp6Address} udp sport ${dnsPort} ip6 saddr set ${vpsIp6Address}
            #     }
            # }

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


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
