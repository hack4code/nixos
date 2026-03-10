{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "vivo-sans";
    version = "1.0";
    dontConfigue = true;

    src = pkgs.fetchzip {
        url = "https://developersstatic.vivo.com/developers/1cdcaef3b39848f290bf90346642ed1d/20241022/vivo%20Sans.zip";
        hash = "sha256-aElDbYVAjRB6fudw3WCK3awIxtsFnA7N7d7sOw67490=";
        curlOpts = "-L --retry 8";
        stripRoot = false;
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        cp -r vivo* $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "vivo Sans";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
