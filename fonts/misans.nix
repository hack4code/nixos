{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "misans";
    version = "1.3";
    dontConfigure = true;
    dontBuild = true;

    src = pkgs.fetchurl {
        url = "https://hyperos.mi.com/font-download/MiSans_Global_ALL.zip";
        hash = "";
        curlOpts = "-L --http1.1 --ignore-content-length --retry 8";
    };

    unpackPhase = ''
        ${pkgs.zip}/bin/zip -FF "$src" --out misans.zip
        ${pkgs.unzip}/bin/unzip misans.zip
        ${pkgs.findutils}/bin/find "MiSans Global _ALL/" -iname '*.zip' -exec ${pkgs.unzip}/bin/unzip {} \;
    '';

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        ${pkgs.findutils}/bin/find . -type d -iname '*MiSans*' -exec cp -r {} $out/share/fonts/ \;
        runHook postInstall
    '';

    meta = {
        description = "MiSans fonts";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
