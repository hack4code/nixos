{ pkgs, ... }:

{
    fonts = {
        packages = with pkgs; [
            /* noto */
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            /* roboto */
            roboto-serif
            roboto-mono
            roboto-flex
            /* source code */
            source-code-pro
            /* source han */
            source-han-serif
            source-han-sans
            source-han-mono
            source-han-sans-japanese
            source-han-serif-japanese
            /* intel one */
            intel-one-mono
            /* nerd */
            nerd-fonts.symbols-only
            /* fira */
            fira
            fira-code
            /* awesome */
            font-awesome
            /* console */
            terminus_font
            /* twitter */
            twemoji-color-font
            /* iosevka */
            iosevka
        ];


        fontconfig = {
            defaultFonts = {
                serif = [ "Noto Serif" "Source Han Serif" ];
                sansSerif = [ "Noto Sans" "Source Han Sans" ];
                monospace = [ "Roboto Mono" "Fira Mono" ];
                emoji = [ "Noto Color Emoji" ];
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

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        earlySetup = true;
        font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
        packages = with pkgs; [ terminus_font ];
        keyMap = "us";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
