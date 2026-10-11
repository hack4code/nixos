{ pkgs ? import <nixpkgs> {} }:

let
    tag = "0.4.9";
in
pkgs.stdenv.mkDerivation {
    pname = "google-fonts";
    version = tag;
    dontConfigure = true;

    src = pkgs.fetchFromGitHub {
        owner = "google";
        repo = "fonts";
        tag = tag;
        hash = "";
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
        cp -r ofl/happymonkey $out/share/fonts/
        cp -r ufl/ubuntu* $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "google fonts";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
