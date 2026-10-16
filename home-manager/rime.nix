{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        # home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
        #     executable = false;
        #     force = true;
        #     text = ''
        #         menu:
        #             page_size: 5
        #     '';
        # };

        home.file.".local/share/fcitx5/rime/luna_pinyin.custom.yaml" = {
            executable = false;
            force = true;
            text = ''
                patch:
                    "key_binder/bindings":
                        - { when: has_menu, accept: "Control+semicolon", send: Page_Down }
                        - { when: composing, accept: Control+p, send: Up }
                        - { when: composing, accept: Control+n, send: Down }
                        - { when: composing, accept: Control+b, send: Left }
                        - { when: composing, accept: Control+f, send: Right }
                        - { when: composing, accept: Control+a, send: Home }
                        - { when: composing, accept: Control+e, send: End }
                        - { when: composing, accept: Control+d, send: Delete }
                        - { when: composing, accept: Control+k, send: Shift+Delete }
                        - { when: composing, accept: Control+h, send: BackSpace }
                        - { when: composing, accept: Control+g, send: Escape }
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
