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
        homeManagerVersion = "25.11";
        kernelVersion = "6.17.9";
        kernelSha256 = "6d08803b953c509df48d44d3281ed392524321d8bb353eb21c0555790c8f8e06";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
