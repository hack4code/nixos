{ pkgs ? import <nixpkgs> {}, nixOSVersion, ... }:

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
        systemd-python
    ] ++ (if nixOSVersion == "26.11" then
    [
        pkgs.python3Packages.python-mpd2
    ] else
    [
        pkgs.python3Packages.mpd2
    ]);
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
