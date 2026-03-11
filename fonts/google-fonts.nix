{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "google-fonts";
    version = "1.0";
    dontConfigue = true;

    src = pkgs.fetchzip {
        url = "https://github.com/google/fonts/archive/main.zip";
        hash = "sha256-oXIRRG0JMLIGQ9zo0IZvwKzFnZjT7k3klmAXrhEdLhU=";
        curlOpts = "-L --retry 8";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        cp -r ofl/roboto* $out/share/fonts/
        cp -r ofl/fira* $out/share/fonts/
        cp -r ofl/source* $out/share/fonts/
        cp -r ofl/googlesanscode $out/share/fonts/
        cp -r ofl/notocoloremoji ofl/notosans ofl/notosanssc ofl/notosanstc ofl/notosansmono $out/share/fonts/
        cp -r ofl/notoserif ofl/notoserifsc ofl/notoseriftc $out/share/fonts/
        cp -r ofl/jetbrainsmono $out/share/fonts/
        cp -r ofl/intelonemono $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "google fonts";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
