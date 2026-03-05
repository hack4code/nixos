{ pkgs, ... }:

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
            (
                callPackage ./swei-gothic.nix {}
            )
            /* google fonts */
            (
                callPackage ./google-fonts.nix {}
            )
            /* vivo sans */
            (
                callPackage ./vivo-sans.nix {}
            )
            /* MiSans */
            (
                callPackage ./misans.nix {}
            )
        ];


        fontconfig = {
            enable = true;

            defaultFonts = {
                serif = [
                    "Noto Serif"
                    "Source Han Serif"
                ];

                sansSerif = [
                    "Roboto Flex"
                    "Noto Sans"
                ];

                monospace = [
                    "JetBrains Mono"
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

            localConf = ''
                <?xml version='1.0'?>
                <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
                <fontconfig>
                    <alias>
                        <family>Microsoft YaHei</family>
                        <prefer>
                            <family>Swei Gothic CJK SC</family>
                        </prefer>
                    </alias>

                    <alias>
                        <family>ico-c</family>
                        <prefer>
                            <family>Font Awesome 7 Free</family>
                        </prefer>
                    </alias>
                </fontconfig>
            '';
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
