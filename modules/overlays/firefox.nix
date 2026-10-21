(self: super: {
    firefox-bin-unwrapped = super.firefox-bin-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "158.0.1";
        src = super.fetchurl {
            url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
            hash = "sha256-3ORUcBOSQs8pTrato9GSqbszRpaEKwK3Gt5EihOetBo=";
            curlOpts = "-L --retry 8";
        };
    });
})


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
