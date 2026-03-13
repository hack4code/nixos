{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.7";
        kernelHash = "219fbf2ca9dc4f71684bd815ff795b7ad4a3c56025c1e7f7c45a17dfc19b06c0";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.7.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
