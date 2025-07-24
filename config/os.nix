{ lib, ... }:

{
    options = with lib; with types; {
        nixosVersion = mkOption { type = str; };
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
        hostName = mkOption { type = str; };
    };

    config = {
        nixosVersion = "25.05";
        kernelVersion = "6.15.8";
        kernelSha256 = "d37e92bc16b962a3025df156647bdad90b2db4ff36c7a6137817fe81ef3f28a6";
        hostName = "KISS";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
