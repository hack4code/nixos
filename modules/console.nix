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
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
