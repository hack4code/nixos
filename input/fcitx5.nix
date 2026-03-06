{  pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
            waylandFrontend = true;
            ignoreUserConfig = false;

            addons = with pkgs; [
                rime-data
                rime-cli
                fcitx5-rime
                fcitx5-gtk
                fcitx5-lua
                fcitx5-fluent
            ];
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
