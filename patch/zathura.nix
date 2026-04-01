{
    nixpkgs.config.packageOverrides = pkgs: {
        zathura = pkgs.zathura.override {
            useMupdf = false;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
