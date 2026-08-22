{
    nixpkgs.config.packageOverrides = pkgs: {
        bottles = pkgs.bottles.override {
            removeWarningPopup = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
