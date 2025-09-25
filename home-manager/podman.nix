{ config, ... }:

let
    userName = config.userName;
    vpsV6Range = config.vpsV6Range;
in
{
    home-manager.users.${userName} = {
        home.file.".config/containers/systemd/podmanv6.network" = {
            executable = false;
            force = true;
            text = ''
                [Unit]
                Description=Podman Network With IPv6
                After=NetworkManager-wait-online.service dnscrypt-proxy2.service wg-quick-wg0.service

                [Network]
                DNS=8.8.8.8
                DNS=2001:4860:4860::8888
                DNS=1.1.1.1
                DNS=2606:4700:4700::1111
                IPv6=true
                Subnet=${vpsV6Range}:bbbb::/80

                [Service]
                TimeoutStartSec=900
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
