{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.3.4";
        kernelHash = "4f42afec23d2b72dbf813b9b7cf6a6250bd07c3365384f84b0af4939578d4a16";
        kernelUrl = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v7.x/linux-7.3.4.tar.gz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
