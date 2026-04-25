{ lib, ... }:

{
    options = with lib; with types; {
         colorBackground = mkOption { type = str; };
         colorBackground0 = mkOption { type = str; };
         colorBackground1 = mkOption { type = str; };
         colorBackground2 = mkOption { type = str; };
         colorBackground3 = mkOption { type = str; };
         colorBackground4 = mkOption { type = str; };
         colorForeground = mkOption { type = str; };
         colorBlack = mkOption { type = str; };
         colorLightBlack = mkOption { type = str; };
         colorRed = mkOption { type = str; };
         colorLightRed = mkOption { type = str; };
         colorGreen = mkOption { type = str; };
         colorLightGreen = mkOption { type = str; };
         colorYellow = mkOption { type = str; };
         colorLightYellow = mkOption { type = str; };
         colorBlue = mkOption { type = str; };
         colorLightBlue = mkOption { type = str; };
         colorPurple = mkOption { type = str; };
         colorLightPurple = mkOption { type = str; };
         colorAqua = mkOption { type = str; };
         colorLightAqua = mkOption { type = str; };
         colorWhite = mkOption { type = str; };
         colorLightWhite = mkOption { type = str; };
         colorGray = mkOption { type = str; };
         colorOrange = mkOption { type = str; };
         colorLightOrange = mkOption { type = str; };
    };

    config = {
        colorForeground = "#ebdbb2";
        colorBackground = "#1d2021";
        colorBackground0 = "#282828";
        colorBackground1 = "#3c3836";
        colorBackground2 = "#504945";
        colorBackground3 = "#665c54";
        colorBackground4 = "#7c6f64";
        colorGray = "#a89984";
        colorBlack = "#665c54";
        colorLightBlack = "#7c6f64";
        colorRed = "#cc241d";
        colorLightRed = "#fb4934";
        colorGreen = "#98971a";
        colorLightGreen = "#b8bb26";
        colorYellow = "#d79921";
        colorLightYellow = "#fabd2f";
        colorBlue = "#458588";
        colorLightBlue = "#83a598";
        colorPurple = "#b16286";
        colorLightPurple = "#d3869b";
        colorAqua = "#689d6a";
        colorLightAqua = "#8ec07c";
        colorWhite = "#a89984";
        colorLightWhite = "#bdae93";
        colorOrange = "#d65d0e";
        colorLightOrange = "#fe8019";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
