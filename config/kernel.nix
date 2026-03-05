{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.6";
        kernelHash = "79a0bd03cb58014ffbc5499f3b88ba783cd0b12abaa24612abdd2573e2e3634e";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.19.6.tar.gz";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
