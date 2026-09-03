{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.2.3";
        kernelHash = "74736dadcc7239caa8dcf91c28a59a1ae58551563847c00f75828ea67a1c8343";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v7.x/linux-7.2.3.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
