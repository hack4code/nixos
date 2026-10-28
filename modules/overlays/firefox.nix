(self: super: {
    firefox-bin-unwrapped = super.firefox-bin-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "159.0";
        src = super.fetchurl {
            url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
            hash = "sha256-VFNvzRIK9ITUxWJypaHPSvV7nHE9Gjsed12hkt1UH80=";
            curlOpts = "-L --retry 8";
        };
    });
})


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
