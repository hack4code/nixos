{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.0.4";
        kernelHash = "c774028e7eccdd4cd30710b70e54bb7981189a4bfa28477bd297e4295d915fe1";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v7.x/linux-7.0.4.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
