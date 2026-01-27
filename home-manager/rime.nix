{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
            executable = false;
            force = true;
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
            executable = false;
            force = true;
            text = ''
                patch:
                    "key_binder/bindings":
                        - { when: has_menu, accept: "Control+semicolon", send: Page_Down }
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
