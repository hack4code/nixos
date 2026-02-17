{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.2";
        kernelHash = "bd0e4caed4599338a8d390c54356efb39b8452cde1de804849f521ef6a65da19";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.2.tar.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
