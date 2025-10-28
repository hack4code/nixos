{ pkgs ? import <nixpkgs> {}, ... }:

let
    version = "6.16.3";
in
(
    pkgs.linuxPackages_custom {
        version = version;
        src = pkgs.fetchurl {
            url = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "80439ba055c12f541abf44b8fc3c9b825a8f42fc25ce67462ec7e556c5790b85";
        };
        configfile = ./config;
    }
)


# vim: ts=4 sw=4 sts=4 ft=nix et:
