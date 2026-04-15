{ config, pkgs, ... }:
let
    userName = config.userName;
    userHome = config.userHome;
    uid = config.uid;
    userPassWord = config.userPassWord;
in
{
    users =
    {
        defaultUserShell = pkgs.zsh;

        users = {
            ${userName} = {
                isNormalUser = true;
                home = userHome;
                uid = uid;
                description = "Sky Walker";
                initialPassword = userPassWord;
                linger = true;
                extraGroups = [
                    "audio"
                    "input"
                    "networkmanager"
                    "podman"
                    "tss"
                    "video"
                    "wheel"
                    "wireshark"
                ];
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
