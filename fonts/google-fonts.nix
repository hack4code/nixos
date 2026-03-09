{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    pname = "google-fonts";
    version = "1.0";
    dontConfigue = true;

    src = pkgs.fetchzip {
        url = "https://github.com/google/fonts/archive/main.zip";
        hash = "sha256-ZV7yHB17wFlk8lmzMfmdLge6w6g7ESE1L66nvBMb6Js=";
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


# vim: ts=4 sw=4 sts=4 ft=nix et:
