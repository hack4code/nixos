{ pkgs ? import <nixpkgs> {} }:

# let
#     rtorrent-rpc = pkgs.python3.pkgs.buildPythonPackage (finalAttrs: {
#         pname = "rtorrent-rpc";
#         version = "0.9.4";
#         pyproject = true;
#         dontCheckRuntimeDeps = true;
#
#         src = pkgs.fetchPypi {
#             inherit (finalAttrs) version;
#             pname = "rtorrent_rpc";
#             hash = "sha256-BL2FwwVJ7G2IiVZ0GnA1AJBT2NN2bZmk/6NaShG9txU=";
#         };
#
#         build-system = with pkgs.python3.pkgs; [
#             flit-core
#             setuptools
#         ];
#
#         dependencies = with pkgs.python3.pkgs; [
#             urllib3
#             bencode-py
#             certifi
#             typing-extensions
#         ];
#
#         doCheck = false;
#
#         meta = {
#             homepage = "https://github.com/trim21/rtorrent-rpc";
#             description = "rtorrent rpc";
#         };
#     });
# in
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
        systemd-python
    ];
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
