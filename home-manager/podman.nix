{ config, pkgs, lib, ... }:

let
    userName = config.userName;
    vpsName = config.vpsName;
    vpsV6Range = config.vpsV6Range;
    podmanNetworkName = config.podmanNetworkName;
in
{

    home-manager.users.${userName} = {
        home.file.".config/systemd/user/podman-user-wait-network-online.service.d/50-patch.conf" = {
            executable = false;
            force = true;
            text = ''
                [Service]
                ExecSearchPath=${lib.makeBinPath (with pkgs; [bashInteractive systemd coreutils openssh])}:/bin
                ExecStartPre=bash -c 'while ! ssh -q -T ${vpsName} exit &>/dev/null; do sleep 24s; done'
            '';
        };

        services.podman = {
            enable = true;

            settings = {
                registries = {
                    search = [
                        "quay.io"
                        "docker.io"
                        "mirror.ccs.tencentyun.com"
                    ];
                };
            };

            networks = {
                "${podmanNetworkName}" = {
                    autoStart = true;
                    description = "podman ipv6 network";
                    driver = "bridge";
                    subnet = "${vpsV6Range}:bbbb::/80";
                    extraConfig = {
                        Network = {
                            IPv6=true;
                        };
                        Service = {
                            TimeoutStartSec = 900;
                        };
                    };
                    extraPodmanArgs = [
                        "--dns=1.1.1.1"
                        "--dns=2606:4700:4700::1111"
                    ];
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
