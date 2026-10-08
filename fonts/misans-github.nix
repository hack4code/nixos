{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
    pname = "misans";
    version = "5.0.0";
    dontConfigure = true;
    dontBuild = true;

    src = pkgs.fetchurl {
        url = "https://github.com/dsrkafuu/misans/archive/refs/tags/v${version}.zip";
        hash = "sha256-xa7rOpPzJKJ7UA/wwUKvkN7B2Mcyhk4WQpHLgjewdd8=";
        curlOpts = "-L --retry 8";
    };

    unpackPhase = ''
        ${pkgs.unzip}/bin/unzip $src
    '';

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        rm -f misans*/raw/*.json
        cp -r misans*/raw/* $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "MiSans fonts";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
