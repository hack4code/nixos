{ config, pkgs ? import <nixpkgs> {} }:

let
    socks5Proxy = config.socks5Proxy;
    tag = "1.110";
in
pkgs.stdenv.mkDerivation {
    pname = "WenYuanFonts";
    version = tag;
    dontConfigure = true;

    src = pkgs.fetchFromGitHub {
        owner = "takushun-wu";
        repo = "WenYuanFonts";
        tag = "v${tag}";
        hash = "sha256-H3YZybt2QuM3KPZZjgxzCbOmWYImtxZG0qw482UJsIc=";
        curlOpts = "-L --retry 8 --proxy ${socks5Proxy}";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        cp -r otf/ ttf/ ttfC/ vf/ $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "WenYuan Font";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
