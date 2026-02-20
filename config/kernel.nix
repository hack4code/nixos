{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.3";
        kernelHash = "cb44ae35c6f4dc8e75fa8fc67ff033e36fe2465cad8ed1710e05f73a125c9171";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.3.tar.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
