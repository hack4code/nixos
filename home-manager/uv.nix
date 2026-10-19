{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.uv = {
            enable = true;

            settings = {
                concurrent-builds = 4;
                concurrent-downloads = 4;
                concurrent-installs = 4;

                extra-index-url = [
                    "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
                    "https://mirrors.ustc.edu.cn/pypi/simple/"
                ];

                pip = {
                    extra-index-url = [
                        "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
                        "https://mirrors.ustc.edu.cn/pypi/simple/"
                    ];
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
