{ config, pkgs ? import <nixpkgs> {} }:

let
    socks5Proxy = config.socks5Proxy;
    tag = "1.530";
in
pkgs.stdenv.mkDerivation {
    pname = "LxgwWenKai";
    version = tag;
    dontConfigure = true;

    src = pkgs.fetchFromGitHub {
        owner = "lxgw";
        repo = "LxgwWenKai";
        tag = "v${tag}";
        hash = "sha256-PLqSMbKjSMQlM6Q1AihMdu4lcyo105orOE9wwH0k5X8=";
        curlOpts = "-L --retry 8 --proxy ${socks5Proxy}";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/
        cp fonts/TTF/*.ttf $out/share/fonts/
        runHook postInstall
    '';

    meta = {
        description = "LxgwWenKai Font";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
