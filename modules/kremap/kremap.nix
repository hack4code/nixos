{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "kremap";
    version = "1.0";
    src = ./src;

    buildInputs = with pkgs; [
        systemd
        libevdev
        json_c
        libgcc
    ];

    buildPhase = ''
        $CC -o kremap -I ${pkgs.libevdev}/include/libevdev-1.0 -L ${pkgs.libevdev}/lib -L ${pkgs.json_c}/lib -l systemd -l evdev -l json-c kremap.c
    '';

    installPhase = ''
        mkdir -p $out/bin
        cp kremap $out/bin/kremap
    '';
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
