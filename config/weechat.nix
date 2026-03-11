{ lib, ... }:

{
    options = with lib; with types; {
        weechatUserName = mkOption {type = str; };
        weechatNickNames = mkOption {type = listOf str; };
        liberaChannels = mkOption { type = listOf str; };
        liberaUserName = mkOption { type = str; };
        liberaPassword = mkOption { type = str; };
        oftcChannels = mkOption { type = listOf str; };
        oftcUserName = mkOption { type = str; };
        oftcPassword = mkOption { type = str; };
    };

    config = {
        weechatUserName = "";
        weechatNickNames = [ ];
        liberaChannels = [ ];
        liberaUserName = "";
        liberaPassword = "";
        oftcChannels = [ ];
        oftcUserName = "";
        oftcPassword = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
