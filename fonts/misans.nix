{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "misans";
    version = "1.2";
    dontConfigure = true;
    dontBuild = true;

    src = pkgs.fetchurl {
        # url = "https://hyperos.mi.com/font-download/MiSans_Global_ALL.zip";
        # hash = "sha256-IyKgHjE4Zho9dpgM/YFn9wS76mBEXflKAMedPWroW1c=";
        url = "https://github.com/dsrkafuu/misans/archive/refs/tags/v4.1.0.zip";
        hash = "sha256-Se4tmsfy5h4V5q9oAa/GORxnw+umZmJycA/3VAM6UaY=";
        curlOpts = "-L --retry 8";
    };

    unpackPhase = ''
        ${pkgs.unzip}/bin/unzip $src
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
