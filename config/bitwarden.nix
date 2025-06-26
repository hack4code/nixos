{ config, lib, ... }:

{
    options = with lib; with types; {
        bwSession = mkOption { type = str; };
    };

    config = {
        bwSession = "kvlONagtEwA+h0iuxKP6FJtlyeJig2VNfP98GuBulFoXRzLTzd5wERhuWiu5iKkDvns+PBiKCcc0BHHtnpjzKg==";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
