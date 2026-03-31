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
        /* gtk */
        gtkColorScheme = "light";
        gtkIconTheme = "Adwaita";
        gtkFontName = "Roboto Condensed";
        gtkFontSize = 10;
        /* qt */
        qtThemeName = "adwaita";
        qtStyleName = "breeze";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
