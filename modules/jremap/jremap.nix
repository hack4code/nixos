{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "jremap";
    version = "1.0";
    src = ./src;

    buildInputs = with pkgs; [
        systemd
        libevdev
        libgcc
    ];

    buildPhase = ''
        $CC -o jremap -I ${pkgs.libevdev}/include/libevdev-1.0 -L ${pkgs.libevdev}/lib -l systemd -l evdev jremap.c
    '';

    installPhase = ''
        mkdir -p $out/bin
        cp jremap $out/bin/
    '';
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
