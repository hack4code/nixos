{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.10";
        kernelHash = "8dd378603074c6e474e627e030de8f1910efd5365bf7d1c3936c8b7e5ac3fd3c";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.10.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
