{ config, pkgs, ... }:

let
    userName = config.userName;
    cursorName = config.cursorName;
    cursorSize = config.cursorSize;
    qtThemeName = config.qtThemeName;
    qtStyleName = config.qtStyleName;
    gtkColorScheme = config.gtkColorScheme;
    gtkIconTheme = config.gtkIconTheme;
    gtkFontName = config.gtkFontName;
    gtkFontSize = config.gtkFontSize;
in
{
    home-manager.users.${userName} = {
        qt = {
            enable = true;

            platformTheme = {
                name = qtThemeName;
            };

            style = {
                name = qtStyleName;
                package = pkgs.adwaita-qt;
            };
        };

        gtk = {
            enable = true;

            colorScheme = gtkColorScheme;

            iconTheme = {
                name = gtkIconTheme;
                package = pkgs.adwaita-icon-theme;
            };

            cursorTheme = {
                name = cursorName;
                size = cursorSize;
                package = pkgs.graphite-cursors;
            };

            font = {
                name = gtkFontName;
                size = gtkFontSize;
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
