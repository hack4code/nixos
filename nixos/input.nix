{ pkgs-stable, ... }:

{
    i18n.inputMethod.enable = true;
    i18n.inputMethod.type = "fcitx5";
    i18n.inputMethod.fcitx5 = {
        addons = with pkgs-stable; [
            fcitx5-chinese-addons
            fcitx5-rime
            fcitx5-nord
            fcitx5-gtk
        ];
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
