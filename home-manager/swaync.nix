{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        services.swaync = {
            enable = true;
            settings = {
                positionX = "right";
                positionY = "top";
                control-center-positionX = "right";
                control-center-positionY = "top";
                control-center-margin-top = 16;
                control-center-margin-bottom = 64;
                control-center-margin-right = 24;
                control-center-margin-left = 8;
                control-center-width = 500;
                control-center-height = 820;
                fit-to-screen = false;
                layer = "overlay";
                cssPriority = "user";
                notification-icon-size = 48;
                timeout = 16;
                timeout-low = 8;
                timeout-critical = 0;
                notification-window-width = 450;
                keyboard-shortcuts = true;
                image-visibility = "when-available";
                transition-time = 160;
                hide-on-clear = true;
                hide-on-action = true;
                script-fail-notify = true;
                widgets = [
                    "title"
                    "notifications"
                ];
                widget-config = {
                    title = {
                        text = "Notification";
                        clear-all-button = false;
                    };
                    label = {
                        text = "Label";
                        max-lines = 4;
                    };
                };
            };
            style = ''
                @define-color bg rgba(28, 28, 28, 0.8);

                .control-center {
                    background: @bg;
                }

                .notification {
                    border-radius: 12px;
                    margin: 6px 6px;
                    background: transparent;
                }

                .notification-row {
                    margin-bottom: 4px;
                    border-radius: 12px;
                    background: transparent;
                }

                .notification-content {
                    font-family: "Roboto Flex,MiSans";
                    font-size: 15px;
                    padding: 6px;
                    border-radius: 8px;
                    background: transparent;
                }

                .summary {
                    font-family: "Roboto Flex,MiSans";
                    font-size: 18px;
                    font-weight: bold;
                    background: transparent;
                }

                .body {
                    font-family: "Roboto Flex,MiSans";
                    font-size: 15px;
                    font-weight: normal;
                    background: transparent;
                }

                .floating-notifications .notification {
                    font-family: "Roboto Flex,MiSans";
                    font-size: 15px;
                    background: @bg;
                }
            '';
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
