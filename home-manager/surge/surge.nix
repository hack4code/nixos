{ pkgs ? import <nixpkgs> {} }:


pkgs.buildGoModule rec {
    pname = "Surge";
    version = "0.6.10";

    src = pkgs.fetchFromGitHub {
        owner = "surge-downloader";
        repo = "Surge";
        tag = "v${version}";
        hash = "sha256-XSoMLDfoQ1igjaKo1kgFT4LVzGGgOi8e+b9GauWIRYI=";
        curlOpts = "-L --retry 8";
    };

    vendorHash = "sha256-IGVt/HanZHglYSZ8WASrzqvTZZtK/bJpJzXNVqSqUfE=";
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
