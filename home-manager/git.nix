{ config, ... }:

let
    userName = config.userName;
    gitUser = config.gitUser;
    gitEmail = config.gitEmail;
in
{
    home-manager.users.${userName} = {
        programs.diff-highlight = {
            enable = false;
            enableGitIntegration = true;
            pagerOpts = [
                "--tabs=4"
                "-RFX"
            ];
        };

        programs.git = {
            enable = true;

            settings = {
                user = {
                    name = gitUser;
                    email = gitEmail;
                };

                init = {
                    defaultBranch = "main";
                };

                pull = {
                    rebase = true;
                };

                "http \"https://github.com\"" = {
                    proxy = "socks5h://10.0.0.1:1080";
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
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
