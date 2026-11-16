{ config, pkgs ? import <nixpkgs> {} }:

let
    socks5Proxy = config.socks5Proxy;
    tag = "1.0.43";
in
pkgs.stdenv.mkDerivation {
    pname = "Sarasa-Gothic";
    version = tag;
    dontConfigure = true;

    src = pkgs.fetchFromGitHub {
        owner = "be5invis";
        repo = "Sarasa-Gothic";
        tag = "v${tag}";
        hash = "sha256-3SkdYliPKGiyDLmhpb1XyPXOIWkXPvuCG8EbIMPvBds=";
        curlOpts = "-L --retry 8 --proxy ${socks5Proxy}";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        ${pkgs.findutils}/bin/find sources/ -type d -exec cp -r {} $out/share/fonts/ \;
        runHook postInstall
    '';

    meta = {
        description = "Sarasa-Gothic Font";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
