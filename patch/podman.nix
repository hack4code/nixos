{ config, pkgs, lib,... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        home.file.".config/systemd/user/podman-user-wait-network-online.service.d/50-exec-search-path.conf".text = ''
            [Service]
            ExecSearchPath=${lib.makeBinPath (with pkgs; [bashInteractive systemd coreutils openssh])}:/bin
        '';

        home.file.".config/systemd/user/podman-user-wait-network-online.service.d/50-exe-start-pre.conf".text = ''
            [Service]
            ExecStartPre=sh -c "while ! ssh -q -T linode exit &>/dev/null; do sleep 12s; done"
        '';
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
