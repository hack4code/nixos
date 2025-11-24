{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "misans";
    version = "1.0";
    dontConfigue = true;

    src = pkgs.fetchurl {
        url = "https://hyperos.mi.com/font-download/MiSans_Global_ALL.zip";
        hash = "sha256-IyKgHjE4Zho9dpgM/YFn9wS76mBEXflKAMedPWroW1c=";
        curlOpts = "-L --retry 8";
    };

    unpackPhase = ''
        ${pkgs.unzip}/bin/unzip $src
        ${pkgs.unzip}/bin/unzip 'MiSans Global _ALL/MiSans.zip'
        ${pkgs.unzip}/bin/unzip 'MiSans Global _ALL/MiSans Latin.zip'
        ${pkgs.unzip}/bin/unzip 'MiSans Global _ALL/MiSans TC.zip'
        ${pkgs.unzip}/bin/unzip 'MiSans Global _ALL/MiSans L3.zip'
    '';

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        cp -r MiSans $out/share/fonts/
        cp -r 'MiSans Latin' $out/share/fonts/
        cp -r 'MiSans TC' $out/share/fonts/
        cp -r 'MiSans L3' $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "MiSans fonts";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
