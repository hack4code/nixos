{ config, lib, pkgs, ... }:

let
    userName = config.userName;
in
{
    systemd.user.services.fcitx5-daemon.wantedBy = lib.mkForce [];

    home-manager.users.${userName} = {
        i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
                waylandFrontend = true;

                addons = with pkgs; [
                    rime-data
                    rime-cli
                    fcitx5-rime
                    fcitx5-gtk
                    fcitx5-lua
                    fcitx5-fluent
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
                            resetStateWhenFocusIn = "Yes";
                            ShareInputState = "No";
                            PreeditEnabledByDefault = "False";
                            ShowInputMethodInformation = "False";
                            showInputMethodInformationWhenFocusIn = "False";
                            CompactInputMethodInformation = "True";
                            ShowFirstInputMethodInformation = "False";
                            PreloadInputMethod = "True";
                            AllowInputMethodForPassword = "False";
                            ShowPreeditForPassword = "False";
                            DefaultPageSize = 8;
                        };
                    };

                    addons = {
                        classicui.globalSection = {
                            Theme = "FluentDark-solid";
                            DarkTheme = "FluentDark-solid";
                            "Vertical Candidate List" = "True";
                            UseAccentColor = "False";
                            WheelForPaging = "False";
                            Font = "\"Swei Gothic CJK SC Medium 12\"";
                            MenuFont = "\"MiSans 10\"";
                            TrayFont = "\"Swei Gothic CJK TC Medium 12\"";
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
                            InputState = "\"Follow Global Configuration\"";
                            PreeditCursorPositionAtBeginning = "True";
                            SwitchInputMethodBehavior = "Clear";
                        };

                        clipboard.globalSection = {
                            # TriggerKey = "Control+;";
                            # PastePrimaryKey = "Super+V";
                            "Number of entries" = 8;
                        };
                    };
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
