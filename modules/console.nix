{ pkgs, ... }:

{
    console = {
        /* disable console, system will hang at graphics.target */
        enable = true;
        earlySetup = false;
        keyMap = "us";
        useXkbConfig = false;
        packages = with pkgs; [
            terminus_font
        ];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
        colors = [
            "002b36"
            "dc322f"
            "859900"
            "b58900"
            "268bd2"
            "d33682"
            "2aa198"
            "eee8d5"
            "002b36"
            "cb4b16"
            "586e75"
            "657b83"
            "839496"
            "6c71c4"
            "93a1a1"
            "fdf6e3"
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
