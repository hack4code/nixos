{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        fonts.fontconfig = {
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

            antialiasing = true;
            hinting = "medium";
            subpixelRendering = "rgb";

            configFile = {
                ico = {
                    enable = true;
                    label = "ico-family-alias";
                    priority = 60;
                    text = ''
                        <?xml version="1.0"?>
                        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
                        <fontconfig>
                            <alias>
                                <family>ico-c</family>
                                <prefer>
                                    <family>Font Awesome 7 Free</family>
                                </prefer>
                            </alias>
                        </fontconfig>
                    '';
                };

                YaHei = {
                    enable = true;
                    label = "yahei-family-alias";
                    priority = 60;
                    text = ''
                        <?xml version="1.0"?>
                        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
                        <fontconfig>
                            <alias>
                                <family>Microsoft YaHei</family>
                                <prefer>
                                    <family>Swei Gothic CJK SC</family>
                                </prefer>
                            </alias>
                        </fontconfig>
                    '';
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
