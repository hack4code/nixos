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
        kernelVersion = "6.16.5";
        kernelSha256 = "76bffbae7eab2a1de1ed05692bef709f43b02a52fe95ae655cacf0fa252213f3";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
