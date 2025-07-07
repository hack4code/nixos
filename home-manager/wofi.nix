{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.wofi = {
            enable = true;

            settings = {
                show = "run";
                always_parse_args = "true";
                show_all = "false";
                insensitive = "true";
                allow_images = "true";
                term = "kitty";
                hide_scroll = "true";
                key_forward = "Ctrl-n";
                key_backward = "Ctrl-p";
                key_exit = "Ctrl-bracketleft";
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
                  border: 1px solid #d79921;
                  border-radius: 4px;
                  margin: 4px;
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
            '';
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
