{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication {
    pname = "rpcd";
    version = "1.0.0";
    src = ./src/.;
    pyproject = true;
    dontCheckRuntimeDeps = true;

    nativeBuildInputs = with pkgs; [
        python3Packages.setuptools
        wrapGAppsHook4
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
        fastapi
        dasbus
        httpx
        uvicorn
        yt-dlp
        i3ipc
        mpd2
        systemd
    ];
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
