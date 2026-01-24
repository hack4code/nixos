{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.7";
        kernelSha256 = "b726a4d15cf9ae06219b56d87820776e34d89fbc137e55fb54a9b9c3015b8f1e";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
