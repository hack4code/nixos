{ pkgs, ... }:

{
    programs = {
        sway = {
            enable = true;

            wrapperFeatures = {
                gtk = true;
            };

            extraPackages = with pkgs; [
                clipman
                urlscan
                w3m
                weechat
                # weechat-matrix-rs
                wl-clipboard
                kitty
                neomutt
                slurp
                swayimg
                urlscan
                w3m
                weechat
                wl-clipboard
                wl-kbptr
                xdg-desktop-portal-termfilechooser
                yazi
                zathura
            ];
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
