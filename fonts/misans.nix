{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "misans";
    version = "0.1";
    dontConfigue = true;

    src = pkgs.fetchurl {
        url = "https://hyperos.mi.com/font-download/MiSans_Global_ALL.zip";
        sha256 = "";
    };

    unpackPhase = ''
        runHook preUnpack
        ${pkgs.unzip}/bin/unzip $src
        runHook postUnpack
    '';

    installPhase = ''
        runHook preInstall
        install -Dm644 MiSans*/*.ttf -t $out/share/fonts/truetype
        runHook postInstall
    '';

    meta = {
        description = "MiSans";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
