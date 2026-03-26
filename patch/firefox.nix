{ pkgs, ...}:

{
    nixpkgs.overlays = [
        (self: super: {
            firefox-bin-unwrapped = super.firefox-bin-unwrapped.overrideAttrs (oldAttrs: rec {
                version = "148.0.2";
                src = pkgs.fetchurl {
                    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
                    hash = "sha256-4Vr9d9qxujwYBrRDbNYDs16h1OBqRStcVy73vBZj11o=";
                };
            });
        })
    ];

    # nixpkgs.config.packageOverrides = pkgs: {
    #     firefox = (pkgs.wrapFirefox (
    #         pkgs.firefox-unwrapped.overrideAttrs (oldAttrs: rec {
    #             version = "148.0.2";
    #             src = pkgs.fetchurl {
    #                 url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    #                 hash = "sha512-Vqk65SNfOHBPL1a2JG2t2t07zvHbeXzKECAvuRm6Lw4UWd76qkHPGI8mkQjvrvG3bMv64z1Q7L1SdlF2tDIL7w==";
    #             };
    #         }))
    #         { }
    #     );
    # };

    # nixpkgs.overlays = [
    #     (
    #         self: super: {
    #             firefox-unwrapped = super.firefox-unwrapped.overrideAttrs (oldAttrs: {
    #                 version = "148.0.2";
    #                 src = pkgs.fetchFromGitHub {
    #                     owner = "mozilla-firefox";
    #                     repo = "firefox";
    #                     tag = "FIREFOX_148_0_2_RELEASE";
    #                     hash = "sha256-E5JBkLCcIdgv01teTJvRY2Q5xPXHEI/ZWoCr745L/q4=";
    #                     curlOpts = "-L --retry 8";
    #                 };
    #             });
    #          }
    #      )
    # ];
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
