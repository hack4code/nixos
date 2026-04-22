{ pkgs, ...}:

{
    nixpkgs.overlays = [(self: super: {
        firefox-bin-unwrapped = super.firefox-bin-unwrapped.overrideAttrs (oldAttrs: rec {
            version = "150.0";
            src = pkgs.fetchurl {
                url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
                hash = "sha256-L/mH6Uv6btUfU9a0uqfw+Ow/wmxMR72fhscNEaoPvWA=";
            };
        });
    })];
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
