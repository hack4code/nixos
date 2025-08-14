{ pkgs, ... }:

let
    swei-gothic = pkgs.callPackage ./swei-gothic.nix {};
    google-fonts = pkgs.callPackage ./google-fonts.nix {};
in
{
    fonts = {
        enableGhostscriptFonts = true;

        fontDir = {
            enable = true;
        };

        packages = with pkgs; [
            # /* noto */
            # noto-fonts
            # noto-fonts-cjk-sans
            # noto-fonts-emoji
            # /* roboto */
            # roboto-serif
            # roboto-mono
            # roboto-flex
            # /* jetbrains */
            # jetbrains-mono
            # /* source code */
            # source-code-pro
            # /* intel one */
            # intel-one-mono
            # /* fira */
            # fira
            # fira-code
            /* source han */
            source-han-serif
            source-han-sans
            source-han-mono
            /* nerd */
            nerd-fonts.symbols-only
            /* awesome */
            font-awesome
            /* twitter */
            twemoji-color-font
            /* iosevka */
            iosevka
            /* swei-gothic */
            swei-gothic
            /* google fonts */
            google-fonts
        ];


        fontconfig = {
            enable = true;

            defaultFonts = {
                serif = [
                    "Noto Serif"
                    "Source Han Serif"
                ];

                sansSerif = [
                    "Noto Sans"
                    "Source Han Sans"
                ];

                monospace = [
                    "Intel One Mono"
                    "JetBrains Mono"
                ];

                emoji = [
                    "Noto Color Emoji"
                    "Twitter Color Emoji"
                ];
            };

            hinting = {
                enable = true;
                autohint = false;
                style = "full";
            };

            subpixel = {
                lcdfilter = "light";
                rgba = "rgb";
            };

            /* firefox emoji */
            useEmbeddedBitmaps = true;
        };
    };

    i18n = {
        defaultLocale = "en_US.UTF-8";
    };

    console = {
        earlySetup = true;
        keyMap = "us";
        packages = with pkgs; [
            terminus_font
        ];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
