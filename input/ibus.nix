{  pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
            rime
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
