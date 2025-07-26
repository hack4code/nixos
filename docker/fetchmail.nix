{ dockerTools, buildEnv, fetchmail, procmail, ... }:

dockerTools.buildImage {
    name = "fetchmail";
    tag = "latest";

    copyToRoot = buildEnv {
        name = "image-root";
        paths = [
            fetchmail
                procmail
        ];
        pathsToLink = [ "/bin" ];
    };

    runAsRoot = ''
    '';

    config = {
        Cmd = [
            "fetchmail"
            "-N"
            "-d3600"
        ];
        WorkingDir = "/data";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
