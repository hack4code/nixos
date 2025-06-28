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
                fcitx5-gtk
                fcitx5-nord
                fcitx5-material-color
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
                        ActiveByDefault = false;
                        resetStateWhenFocusIn = "No";
                        ShareInputState = "No";
                        PreeditEnabledByDefault = false;
                        ShowInputMethodInformation = false;
                        showInputMethodInformationWhenFocusIn = false;
                        CompactInputMethodInformation = false;
                        ShowFirstInputMethodInformation = false;
                        PreloadInputMethod = true;
                        AllowInputMethodForPassword = false;
                        ShowPreeditForPassword = false;
                        DefaultPageSize = 5;
                        AutoSavePeriod = 30;
                    };
                };

                addons = {
                    classicui.globalSection = {
                        "Vertical Candidate List" = "True";
                        Theme = "Nord-Dark";
                        UseAccentColor = "False";
                        WheelForPaging = "False";
                        Font = "\"MiSans 12\"";
                        MenuFont = "\"MiSans 10\"";
                        TrayFont = "\"MiSans 10\"";
                        TrayOutlineColor = "#282828";
                        TrayTextColor = "#ebdbb2";
                        PreferTextIcon = "True";
                        ShowLayoutNameInIcon = "True";
                        UseInputMethodLanguageToDisplayText = "True";
                        PerScreenDPI = "False";
                        ForceWaylandDPI = 0;
                    };

                    rime.globalSection = {
                        PreeditMode = "\"Do not show\"";
                        InputState = "No";
                        PreeditCursorPositionAtBeginning = "True";
                        SwitchInputMethodBehavior = "\"Commit commit preview\"";
                    };

                    clipboard.globalSection = {
                        "Number of entries" = 8;
                    };
                };
            };
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
