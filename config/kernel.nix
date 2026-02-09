{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19";
        kernelHash = "2ddb2a3311b3899862e066db48208f0f1f4b9a0681576226b9c76b2cce66c2df";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.tar.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
