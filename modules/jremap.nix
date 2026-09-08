{ pkgs, lib, ... }:

let
    jremap = pkgs.callPackage ./jremap/jremap.nix { };
in
{
    environment.systemPackages = [ jremap ];

    systemd.services = {
        jremap = {
            enable = true;

            wantedBy = lib.mkForce [];
            description = "Joystick Remap";

            serviceConfig = {
                Type = "exec";
                KillMode = "mixed";
                TimeoutStopSec = 120;
                ExecStart = "${jremap}/bin/jremap";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
