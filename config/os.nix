{ lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        homeManagerVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
        hostName = mkOption { type = str; };
        timeZone = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.11";
        homeManagerVersion = "25.05";
        kernelVersion = "6.16.1";
        kernelSha256 = "ea43491bc7ace1e414b3b2d957f8cf96e7049155123f0acce798accf8da1acba";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
