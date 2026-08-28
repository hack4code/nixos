{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "misans";
    version = "4.1.0";
    dontConfigure = true;
    dontBuild = true;

    src = pkgs.fetchurl {
        url = "https://github.com/dsrkafuu/misans/archive/refs/tags/v4.1.0.zip";
        hash = "sha256-Se4tmsfy5h4V5q9oAa/GORxnw+umZmJycA/3VAM6UaY=";
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
