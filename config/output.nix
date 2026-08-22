{ lib, ... }:

{
    options = with lib; with types; {
        monitorThinkpad = mkOption { type = str; };
        monitorSamsung = mkOption { type = str; };
        monitorExt = mkOption { type = str; };
        bgThinkpad = mkOption { type = str; };
        bgSamsung = mkOption { type = str; };
        bgLock = mkOption { type = str; };
    };

    config = {
        monitorThinkpad = "eDP-1";
        monitorSamsung = "DP-2";
        monitorExt = "Samsung Electric Company LS24A600U H4ZRB00248";
        bgThinkpad = "$HOME/.config/sway/wallpaper/edp-1/the-assassination-of-julius.webp";
        bgSamsung = "$HOME/.config/sway/wallpaper/dp-3/the-death-of-socrates.jpeg";
        bgLock = "$HOME/.config/sway/wallpaper/edp-1/evolution.jpg";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
