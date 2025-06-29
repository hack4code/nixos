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
                control-center-positionX = "none";
                control-center-positionY = "top";
                control-center-margin-top = 16;
                control-center-margin-bottom = 64;
                control-center-margin-right = 24;
                control-center-margin-left = 8;
                control-center-width = 500;
                control-center-height = 820;
                fit-to-screen = true;
                layer = "overlay";
                cssPriority = "application";
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
                widgets = [ "title" "notifications" ];
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
                @define-color cc-bg rgba(42, 42, 42, 0.8);
                @define-color noti-border-color rgba(255, 255, 255, 0.15);
                @define-color noti-bg rgba(55, 55, 55, 0.8);
                @define-color noti-bg-hover rgba(65, 65, 65, 0.8);
                @define-color noti-bg-focus rgba(68, 68, 68, 0.6);
                @define-color noti-close-bg rgba(255, 255, 255, 0.1);
                @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
                @define-color bg-selected rgb(0, 128, 255);

                .notification-row {
                    transition: all 200ms ease;
                    margin-bottom: 4px;
                    border-radius: 12px;
                }

                .notification-row:focus .notification,
                .notification-row:hover .notification {
                    box-shadow: 0 1px 3px 1px rgba(0, 0, 0, 0.5);
                    box-shadow: 0px 0px 0px 3px @bg-selected;
                }

                .control-center .notification-row {
                    opacity: 0.6;
                }

                .notification {
                    transition: all 200ms ease;
                    border-radius: 12px;
                    margin: 6px 6px;
                    box-shadow: 0 1px 3px 1px rgba(0, 0, 0, 0.5);
                }

                .notification-content {
                    background: transparent;
                    padding: 6px;
                    border-radius: 8px;
                    font-size: 15px;
                    font-family: "Roboto,MiSans";
                }

                .body-image {
                    margin-top: 6px;
                    background-color: white;
                    border-radius: 12px;
                }

                .summary {
                    font-size: 18px;
                    font-weight: bold;
                    background: transparent;
                    font-family: "Roboto,MiSans";
                }

                .time {
                    font-size: 18px;
                    font-weight: bold;
                    background: transparent;
                    margin-right: 18px;
                }

                .body {
                    font-size: 15px;
                    font-weight: normal;
                    background: transparent;
                    font-family: "Roboto,MiSans";
                }

                .control-center {
                    background: @cc-bg;
                    border-radius: 12px;
                    background-clip: border-box;
                    padding: 4px;
                }

                .control-center-list {
                    background: transparent;
                }

                .control-center-list-placeholder {
                    opacity: 0.5;
                }

                .floating-notifications .notification {
                    font-size: 15px;
                    font-family: "Roboto,MiSans";
                    background: transparent;
                }

                .blank-window {
                    background: transparent;
                }
            '';
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
