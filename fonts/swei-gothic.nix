{ pkgs ? import <nixpkgs> {} }:

let
    tag = "2.143";
in
pkgs.stdenv.mkDerivation {
    pname = "swei-gothic";
    version = tag;
    dontConfigue = true;

    src = pkgs.fetchFromGitHub {
        owner = "max32002";
        repo = "swei-gothic";
        tag = tag;
        sha256 = "Ko8du9HRmi+k6a3My1r5Zyv1BX362BONy/RH5C9ECSU=";
        curlOpts = "-L";
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/ttf
        install -Dm644 CJK*/*.ttf -t $out/share/fonts/ttf/
        runHook postInstall
    '';

    meta = {
        description = "狮尾圆体";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
