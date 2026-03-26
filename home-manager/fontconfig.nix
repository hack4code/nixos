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
                    label = "ico-font";
                    priority = 60;
                    text = ''
                        <?xml version="1.0"?>
                        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
                        <fontconfig>
                          <match target="pattern">
                            <test qual="any" compare="contains" name="family">
                              <string>ico</string>
                            </test>
                            <edit name="family" mode="assign" binding="same">
                              <string>Symbols Nerd Font</string>
                            </edit>
                          </match>
                        </fontconfig>
                    '';
                };

                YaHei = {
                    enable = true;
                    label = "yahei";
                    priority = 60;
                    text = ''
                        <?xml version="1.0"?>
                        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
                        <fontconfig>
                          <match target="pattern">
                            <test qual="any" compare="contains" name="family">
                              <string>yahei</string>
                            </test>
                            <edit name="family" mode="assign" binding="same">
                              <string>Swei Gothic CJK SC</string>
                            </edit>
                          </match>
                        </fontconfig>
                    '';
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
