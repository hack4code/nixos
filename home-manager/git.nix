{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.git = {
            enable = true;
            userName = "code4hack";
            userEmail = "code4hack+github@gmail.com";
            diff-highlight = {
                enable = true;
                pagerOpts = [
                    "--tabs=4"
                    "-RFX"
                ];
            };
            extraConfig = {
                init = {
                    defaultBranch = "main";
                };
                pull = {
                    rebase = true;
                };
                "https \"https://github.com\"" = {
                    proxy = "socks5://127.0.0.1:1080";
                };
                "http \"https://github.com\"" = {
                    proxy = "socks5://127.0.0.1:1080";
                };

                "credential \"https://github.com\"" = {
                    helper = "!/run/current-system/sw/bin/gh auth git-credential";
                };
                "credential \"https://gist.github.com\"" = {
                    helper = "!/run/current-system/sw/bin/gh auth git-credential";
                };
            };
            ignores = [
                "*~"
                "*.swp"
                "__pycache__"
            ];
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
