{ config, ... }:

let
    userName = config.userName;
    gitUser = config.gitUser;
    gitEmail = config.gitEmail;
in
{
    home-manager.users.${userName} = {
        programs.diff-highlight = {
            enable = true;
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
                };

                "credential \"https://github.com\"" = {
                    helper = "!/run/current-system/sw/bin/gh auth git-credential";
                };

                "credential \"https://gist.github.com\"" = {
                    helper = "!/run/current-system/sw/bin/gh auth git-credential";
                };

                # interactive = {
                #     diffFilter = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight";
                # };

                # pager = {
                #     diff =  "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | ${pkgs.moor}/bin/moor";
                #     show =  "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | ${pkgs.moor}/bin/moor";
                #     log =  "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | ${pkgs.moor}/bin/moor";
                # };
            };

            ignores = [
                "*~"
                "*.swp"
                "__pycache__"
            ];
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
