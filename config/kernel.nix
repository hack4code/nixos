{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "7.0.1";
        kernelHash = "b2c935a36d24980e11e59bed3ca558ea6d67619ec0065faa335cdc0b64d887bf";
        kernelUrl = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.1.tar.xz";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
