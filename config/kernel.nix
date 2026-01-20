{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.6";
        kernelSha256 = "472497197b2f68d4dbf1bc32cc6dc669ca220ff4c0eb0dc39a9cff9a88f9a31b";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
