{ lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        homeManagerVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
        hostName = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.11";
        homeManagerVersion = "25.05";
        kernelVersion = "6.16";
        kernelSha256 = "1a4be2fe6b5246aa4ac8987a8a4af34c42a8dd7d08b46ab48516bcc1befbcd83";
        hostName = "KISS";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
