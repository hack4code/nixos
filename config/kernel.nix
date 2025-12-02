{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelSha256 = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.18";
        kernelSha256 = "9106a4605da9e31ff17659d958782b815f9591ab308d03b0ee21aad6c7dced4b";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
