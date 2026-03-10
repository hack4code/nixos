{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication {
    pname = "openurl";
    version = "1.0.0";
    src = ./src/.;
    pyproject = true;
    dontCheckRuntimeDeps = true;

    nativeBuildInputs = with pkgs; [
        python3Packages.setuptools
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
        httpx
    ];
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
