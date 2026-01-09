{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.4";
        kernelSha256 = "f850139ca5f79c1bf6bb8b32f92e212aadca97bdaef8a83a7cf4ac4d6a525fab";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
