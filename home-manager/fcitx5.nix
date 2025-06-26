{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        i18n.inputMethod.enable = true;
        i18n.inputMethod.type = "fcitx5";
        i18n.inputMethod.fcitx5 = {
            waylandFrontend = true;
            addons = with pkgs; [
                fcitx5-chinese-addons
                fcitx5-rime
                fcitx5-nord
                fcitx5-gtk
            ];

            settings = {
                inputMethod = {
                    GroupOrder."0" = "Default";
                    "Groups/0" = {
                        Name = "Default";
                        "Default Layout" = "us";
                        DefaultIM = "rime";
                    };
                    "Groups/0/Items/0".Name = "keyboard-us";
                    "Groups/0/Items/1".Name = "rime";
                };

                globalOptions = {
                    Behavior = {
                        ActiveByDefault = "False";
                        resetStateWhenFocusIn = "No";
                        ShareInputState = "No";
                        PreeditEnabledByDefault = "False";
                        ShowInputMethodInformation = "False";
                        showInputMethodInformationWhenFocusIn = "False";
                        CompactInputMethodInformation = "False";
                        ShowFirstInputMethodInformation = "False";
                        PreloadInputMethod = "True";
                        AllowInputMethodForPassword = "False";
                        ShowPreeditForPassword = "False";
                        DefaultPageSize = 5;
                        AutoSavePeriod = 30;
                    };
                };
            };
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
