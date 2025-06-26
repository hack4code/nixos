{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
            text = ''
                patch:
                    ascii_composer/good_old_caps_lock: true
                    ascii_composer/switch_key:
                        Caps_Lock: commit_code
                        Shift_L: commit_code
                        Shift_R: noop
                        Control_L: noop
                        Control_R: noop
            '';
        };

        home.file.".local/share/fcitx5/rime/luna_pinyin.custom.yaml" = {
            text = ''
                patch:
                    "key_binder/bindings":
                        - { when: paging, accept: bracketright, send: Page_Up }
                        - { when: has_menu, accept: bracketleft, send: Page_Down }
                        - { when: has_menu, accept: "Control+p", send: Page_Up }
                        - { when: has_menu, accept: "Control+semicolon", send: Page_Down }
                        - { when: has_menu, accept: "Control+h", send: Left }
                        - { when: has_menu, accept: "Control+l", send: Right }
            '';
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
