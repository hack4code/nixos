{ pkgs, ... }:

{
    fonts = {
        enableDefaultPackages = false;
        enableGhostscriptFonts = false;
        fontDir = {
            enable = true;
        };

        packages = with pkgs; [
            /* noto */
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            /* roboto */
            roboto-serif
            roboto-mono
            roboto-flex
            /* jetbrains */
            jetbrains-mono
            /* source code */
            source-code-pro
            /* intel one */
            intel-one-mono
            /* fira */
            fira
            fira-code
            /* gtk */
            adwaita-fonts
            /* iosevka */
            iosevka
            /* source han */
            source-han-serif
            source-han-serif-vf-otf
            source-han-serif-vf-ttf
            source-han-sans
            source-han-sans-vf-otf
            source-han-sans-vf-ttf
            source-han-mono
            source-han-code-jp
            /* ubuntu */
            ubuntu-classic
            ubuntu-sans
            ubuntu-sans-mono
            /* nerd */
            nerd-fonts.symbols-only
            # nerd-fonts.terminess-ttf
            /* terminus */
            terminus_font
            /* twitter */
            twemoji-color-font
            /* maple */
            maple-mono.variable
            maple-mono.CN
            /* google */
            googlesans-code
            /* MiSans */
            (
                callPackage ./misans.nix { inherit pkgs; }
            )
            /* vivo sans */
            (
                callPackage ./vivo-sans.nix { inherit pkgs; }
            )
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
