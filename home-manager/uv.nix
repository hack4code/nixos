{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        home.file.".config/uv/uv.toml" = {
            executable = false;
            force = true;
            text = ''
                [[index]]
                url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
                default = true
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
