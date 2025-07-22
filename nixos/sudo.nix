{ config, ... }:

let
    userName = config.userName;
in
{
    security.sudo.extraRules = [
        {
            users = [ "${userName}" ];
            commands = [
                {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                }
            ];
        }
    ];
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
