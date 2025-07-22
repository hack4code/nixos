{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
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

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
