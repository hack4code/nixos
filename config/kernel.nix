{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.3";
        kernelSha256 = "7a8879167b89c4bae077d6f39c4f2130769f05dbdad2aad914adab9afb7d7f9a";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
