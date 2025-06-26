{ config, pkgs, lib, ... }:

{
    options = with lib; with types; {
        monitorThinkpad = mkOption { type = str; };
        monitorSamsung = mkOption { type = str; };
        bgThinkpad = mkOption { type = str; };
        bgSamsung = mkOption { type = str; };
    };

    config = {
        monitorThinkpad = "Chimei Innolux Corporation 0x1301 Unknown";
        monitorSamsung = "Samsung Electric Company LS24A600U H4ZRB00248";
        bgThinkpad = "$HOME/.config/sway/wallpaper/a-view-of-mount-fuji-across-lake-suwa-by-hokusai.png";
        bgSamsung = "$HOME/.config/sway/wallpaper/japanese-sea.png";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
