{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.5";
        kernelHash = "5a0f40a61650642bb4556e8dbf44051ed3592cc1583959c81e0daa471ba59e9c";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.5.tar.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
