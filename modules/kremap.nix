{ pkgs, ... }:

let
    kremap = pkgs.callPackage ./kremap/kremap.nix {};
in
{
    environment.systemPackages = [ kremap ];

    systemd.services = {
        kremap = {
            wantedBy = [ "multi-user.target" ];
            after = [ "systemd-udevd.service" ];
            description = "Keyboard Remap";
            serviceConfig = {
                Type = "exec";
                KillMode = "mixed";
                TimeoutStopSec = 120;
                ExecStart = "${kremap}/bin/kremap";
                # Restart="always";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
