{ lib, ... }:

{
    options = with lib; with types; {
        cursorName = mkOption { type = str; };
        cursorSize = mkOption { type = int; };
        qtThemeName = mkOption { type = str; };
        qtStyleName = mkOption { type = str; };
        gtkColorScheme = mkOption { type = str; };
        gtkIconTheme = mkOption { type = str; };
        gtkFontName = mkOption { type = str; };
        gtkFontSize = mkOption { type = int; };
    };

    config = {
        cursorName = "graphite-dark-nord";
        cursorSize = 18;
        qtThemeName = "adwaita";
        qtStyleName = "adwaita-highcontrast";
        gtkColorScheme = "light";
        gtkIconTheme = "Adwaita";
        gtkFontName = "Roboto Flex";
        gtkFontSize = 10;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
