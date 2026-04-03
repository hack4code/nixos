{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.11";
        kernelHash = "765bf4a8213e98e490bdfa0b3585ace74bb5f0aff04a9bcbfb379b34b6e3ce52";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.11.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
