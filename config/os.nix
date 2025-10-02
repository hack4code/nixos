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
        kernelVersion = "6.17.1";
        kernelSha256 = "a53dbe3f41491922a61f17c5cc551e88f544d5411aeb1c8c65c402795c4f4da0";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
