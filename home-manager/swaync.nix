{ config, lib, ... }:

let
    userName = config.userName;
in
{
    systemd.user.services.swaync.wantedBy = lib.mkForce [];

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
                control-center-width = 480;
                control-center-height = 800;
                fit-to-screen = true;
                layer = "overlay";
                cssPriority = "user";
                notification-icon-size = 24;
                timeout = 16;
                timeout-low = 8;
                timeout-critical = 0;
                notification-window-width = 480;
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
                        text = "notification";
                        clear-all-button = false;
                    };
                    label = {
                        text = "label";
                        max-lines = 4;
                    };
                };
            };
            style = ''
                :root {
                  --cc-bg: rgba(46, 46, 46, 0.7);
                  --noti-border-color: rgba(255, 255, 255, 0.15);
                  --noti-bg: 38, 38, 38;
                  --noti-bg-alpha: 0.95;
                  --noti-bg-darker: rgb(38, 38, 38);
                  --noti-bg-hover: rgb(56, 56, 56);
                  --noti-bg-focus: rgba(68, 68, 68, 0.6);
                  --noti-close-bg: rgb(78, 78, 78);
                  --noti-close-bg-hover: rgb(94, 94, 94rgba(68, 68, 68, 0.6));
                  --text-color: rgb(255, 255, 255);
                  --text-color-disabled: rgb(150, 150, 150);
                  --bg-selected: rgb(0, 128, 255);
                  --notification-icon-size: 64px;
                  --notification-app-icon-size: calc(var(--notification-icon-size) / 3);
                  --notification-group-icon-size: 32px;
                  --border: 1.5px solid var(--noti-border-color);
                  --border-radius: 25px;
                  --notification-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3),
                    0 1px 3px 1px rgba(0, 0, 0, 0.7), 0 2px 6px 2px rgba(0, 0, 0, 0.3);
                  --font-size-body: 15px;
                  --font-size-summary: 16px;
                }

                @define-color cc-bg rgba(46, 46, 46, 0.7);
                @define-color noti-border-color rgba(255, 255, 255, 0.15);
                @define-color noti-bg rgba(48, 48, 48, 0.8);
                @define-color noti-bg-opaque rgb(48, 48, 48);
                @define-color noti-bg-darker rgb(38, 38, 38);
                @define-color noti-bg-hover rgb(56, 56, 56);
                @define-color noti-bg-hover-opaque rgb(56, 56, 56);
                @define-color noti-bg-focus rgba(68, 68, 68, 0.6);
                @define-color noti-close-bg rgba(255, 255, 255, 0.1);
                @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
                @define-color text-color rgb(255, 255, 255);
                @define-color text-color-disabled rgb(150, 150, 150);
                @define-color bg-selected rgb(0, 128, 255);
                notificationwindow, blankwindow, blankwindow {
                  background: transparent;
                }

                /*
                .close-button {
                  display: none;
                }
                */

                .notification-row {
                  background: none;
                  outline: none;
                }

                .notification-row .notification-background {
                  padding: 0;
                  box-shadow: none;
                }

                .notification-row .notification-background .notification {
                  padding: 0;
                  transition: var(--hover-tranistion);
                  background: rgba(var(--noti-bg), var(--noti-bg-alpha));
                  box-shadow: none;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content {
                  background: transparent;
                  border-radius: var(--border-radius);
                  padding: 0;
                  box-shadow: none;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .image {
                  -gtk-icon-filter: none;
                  -gtk-icon-size: var(--notification-icon-size);
                  border-radius: 100px;
                  margin: 4px;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .app-icon {
                  -gtk-icon-filter: none;
                  -gtk-icon-size: var(--notification-app-icon-size);
                  -gtk-icon-shadow: 0 1px 4px black;
                  margin: 6px;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .text-box label {
                  filter: none;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .summary {
                  font-size: var(--font-size-summary);
                  font-weight: bold;
                  background: transparent;
                  color: var(--text-color);
                  text-shadow: none;
                  margin-bottom: 3px;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .time {
                  font-size: var(--font-size-summary);
                  font-weight: bold;
                  background: transparent;
                  color: var(--text-color);
                  text-shadow: none;
                  margin-right: 30px;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .body {
                  font-size: var(--font-size-body);
                  font-weight: normal;
                  background: transparent;
                  color: var(--text-color);
                  text-shadow: none;
                  line-height: 1.20;
                  margin-bottom: 3px;
                }

                .notification-row .notification-background .notification .notification-default-action .notification-content .body-image {
                  margin-top: 4px;
                  background-color: white;
                  -gtk-icon-filter: none;
                }

                .notification-group {
                  transition: opacity 200ms ease-in-out;
                }

                .notification-group:focus {
                  background: var(--noti-bg-focus);
                }


                /*
                .notification-group .notification-group-close-button .close-button {
                  display: none;
                }
                */

                .notification-group .notification-group-buttons, .notification-group .notification-group-headers {
                  margin: 0 16px;
                  color: var(--text-color);
                }

                .notification-group .notification-group-headers .notification-group-icon {
                  color: var(--text-color);
                  -gtk-icon-size: var(--notification-group-icon-size);
                }

                .notification-group .notification-group-headers .notification-group-header {
                  color: var(--text-color);
                }

                .notification-group.collapsed.not-expanded {
                  opacity: 0.4;
                }

                .notification-group.collapsed .notification-row .notification {
                  background-color: rgba(var(--noti-bg), 1);
                }

                .notification-group.collapsed .notification-row:not(:last-child) .notification-action,
                .notification-group.collapsed .notification-row:not(:last-child) .notification-default-action {
                  opacity: 0;
                }

                .notification-group.collapsed:hover .notification-row:not(:only-child) .notification {
                  background-color: var(--noti-bg-hover);
                }

                .control-center {
                  background: var(--cc-bg);
                  color: var(--text-color);
                  border-radius: var(--border-radius);
                  border: var(--border);
                }

                .control-center .control-center-list-placeholder {
                  opacity: 0.5;
                }

                .control-center .control-center-list {
                  background: transparent;
                }

                .control-center .control-center-list .notification {
                  box-shadow: none;
                }

                .control-center .control-center-list .notification .notification-default-action,
                .control-center .control-center-list .notification .notification-action {
                  transition: var(--group-collapse-tranistion), var(--hover-tranistion);
                  box-shadow: none;
                }

                .control-center .control-center-list .notification-group,
                .control-center .control-center-list .notification-group .notification-row,
                .control-center .control-center-list .notification-group .notification-background {
                  background-color: transparent;
                  box-shadow: none;
                  border: none;
                }

                .blank-window {
                  background: transparent;
                }

                .floating-notifications {
                  background: transparent;
                  margin-right: 24px;
                }

                .floating-notifications .notification {
                  box-shadow: none;
                }

                .widget {
                  margin: 8px;
                  padding: 8px;
                  border-radius: var(--border-radius);
                }

                .widget-title > label {
                  margin-right: 8px;
                  font-size: 1.5rem;
                }

                .widget-title > button {
                  margin-left: 8px;
                  border-radius: var(--border-radius);
                }
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
