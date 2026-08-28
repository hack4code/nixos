{ pkgs, ... }:

{
    fonts = {
        enableDefaultPackages = false;
        enableGhostscriptFonts = false;
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
            /* gtk */
            adwaita-fonts
            /* iosevka */
            nerd-fonts.iosevka-term
            /* source han */
            source-han-serif
            source-han-serif-vf-otf
            source-han-serif-vf-ttf
            source-han-sans
            source-han-sans-vf-otf
            source-han-sans-vf-ttf
            source-han-mono
            source-han-code-jp
            /* nerd */
            nerd-fonts.symbols-only
            /* console font */
            terminus_font
            /* twitter */
            twemoji-color-font
            /* google fonts */
            (
                callPackage ./google-fonts.nix {}
            )
            /* MiSans */
            # (
            #     callPackage ./misans.nix {}
            # )
            (
                callPackage ./misans-github.nix {}
            )
            /* vivo sans */
            (
                callPackage ./vivo-sans.nix {}
            )
            /* swei-gothic */
            # (
            #     callPackage ./swei-gothic.nix {}
            # )
        ];


        fontconfig = {
            enable = true;

            includeUserConf = true;

            defaultFonts = {
                serif = [
                    "Noto Serif"
                    "Source Han Serif"
                ];

                sansSerif = [
                    "Adwaita Sans"
                    "MiSans"
                ];

                monospace = [
                    "Adwaita Mono"
                    "MiSans"
                ];

                emoji = [
                    "Noto Color Emoji"
                    "Twitter Color Emoji"
                ];
            };

            antialias = true;

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
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
