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


# vim: ts=4 sw=4 sts=4 ft=nix et:
