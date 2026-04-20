{ pkgs, ...}:

{
    nixpkgs.overlays = [(self: super: {
        firefox-bin-unwrapped = super.firefox-bin-unwrapped.overrideAttrs (oldAttrs: rec {
            version = "148.0.2";
            src = pkgs.fetchurl {
                url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
                hash = "sha256-4Vr9d9qxujwYBrRDbNYDs16h1OBqRStcVy73vBZj11o=";
            };
        });
    })];
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
