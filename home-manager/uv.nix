{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.uv = {
            enable = true;
            settings = {
                python-preference = "only-managed";
                concurrent-downloads = 4;
                pip = {
                    python-platform = "x86_64-unknown-linux-gnu";
                    index-url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
                    extra-index-url = [
                        "http://mirrors.aliyun.com/pypi/simple/"
                        "https://mirrors.ustc.edu.cn/pypi/simple/"
                        "https://mirrors.cloud.tencent.com/pypi/simple/"
                    ];
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
