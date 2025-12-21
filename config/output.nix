{ lib, ... }:

{
    options = with lib; with types; {
        monitorThinkpad = mkOption { type = str; };
        monitorSamsung = mkOption { type = str; };
        bgThinkpad = mkOption { type = str; };
        bgSamsung = mkOption { type = str; };
    };

    config = {
        monitorThinkpad = "eDP-1";
        monitorSamsung = "Samsung Electric Company LS24A600U H4ZRB00248";
        bgThinkpad = "$HOME/.config/sway/wallpaper/the-assassination-of-julius.webp";
        bgSamsung = "$HOME/.config/sway/wallpaper/the-death-of-socrates.jpeg";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
