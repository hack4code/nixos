{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.5";
        kernelSha256 = "189d1f409cef8d0d234210e04595172df392f8cb297e14b447ed95720e2fd940";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
