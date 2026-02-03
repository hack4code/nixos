{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.8";
        kernelSha256 = "37f0c5d5c242c1d604e87d48f08795e861a5a85f725b4ca11d0a538f12ff8cff";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
