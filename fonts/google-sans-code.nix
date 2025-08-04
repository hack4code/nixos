{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "google-sans-code";
    version = "0.1";
    dontConfigue = true;

    src = pkgs.fetchurl {
        url = "";
        sha256 = "";
    };

    installPhase = ''
        mkdir -p $out/share/fonts/
    '';

    meta = {
        description = "google sans code font";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
