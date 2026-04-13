{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.0";
        kernelHash = "c6343795c8c7e4feff55f5b309365c8e0eaf49cd6abcb412e32315313f149536";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v7.x/linux-7.0.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
