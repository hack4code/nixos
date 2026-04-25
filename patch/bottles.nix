{pkgs-stable, ...}:

{
    nixpkgs.config.packageOverrides = pkgs: {
        bottles = pkgs-stable.bottles.override {
            removeWarningPopup = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
