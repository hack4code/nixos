{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18.2";
        kernelSha256 = "558c6bbab749492b34f99827fe807b0039a744693c21d3a7e03b3a48edaab96a";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
