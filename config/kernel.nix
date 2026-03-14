{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "6.19.8";
        kernelHash = "aada4722db8bcfa0b9732851856d405082b6a4fa2e3ab067be8db17cdd115b38";
        kernelUrl = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.8.tar.xz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
