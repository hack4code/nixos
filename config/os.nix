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
        kernelVersion = "6.18";
        kernelSha256 = "9106a4605da9e31ff17659d958782b815f9591ab308d03b0ee21aad6c7dced4b";
        hostName = "KISS";
        timeZone = "Asia/Shanghai";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
