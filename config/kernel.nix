{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.2.7";
        kernelHash = "9baabbdf22ca1dd55d98df1d79785f674928c7724cb016bd17ec735729db60ad";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v7.x/linux-7.2.7.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
