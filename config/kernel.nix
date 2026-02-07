{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.9";
        kernelSha256 = "030115ff8fb4cb536d8449dc40ebc3e314e86ba1b316a6ae21091a11cc930578";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
