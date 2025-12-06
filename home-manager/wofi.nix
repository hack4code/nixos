{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.wofi = {
            enable = true;

            settings = {
                show = "run";
                width = 280;
                always_parse_args = "true";
                show_all = "false";
                insensitive = "true";
                allow_images = "true";
                term = "kitty";
                hide_scroll = "true";
                key_forward = "Ctrl-j";
                key_backward = "Ctrl-k";
                key_exit = "Ctrl-bracketleft";
                prompt="";
                close_on_focus_loss="true";
            };

            style = ''
                window {
                  margin: 5px;
                  background-color: rgba(0, 0, 0, 0.95);
                  border: 1px solid #b16286;
                  border-radius: 4px;
                }

                #input {
                  font-family: "Roboto Mono";
                  font-size: 20px;
                  color: #ebdbb2;
                  background: transparent;
                  border: 1px solid #fb4934;
                  border-radius: 4px;
                  margin: 4px;
                  box-shadow: none;
                }

                #input > image.left {
                  -gtk-icon-transform:scaleX(0);
                }

                #input > image.right {
                  -gtk-icon-transform:scaleX(0);
                }

                #inner-box {
                  margin: 4px;
                }

                #outer-box {
                  margin: 4px;
                  border: 1px transparent;
                }

                #text {
                  color: #98971a;
                  font-size: 18px;
                  font-family: "Roboto Mono";
                  margin: 2px;
                }

                #text:selected {
                  color: #fb4934;
                }

                #entry:selected {
                  background-color: rgba(0, 0, 0, 0);
                }

                #img {
                    display: none;
                }
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
