{ pkgs, ...}:

{
    nixpkgs.overlays = [(self: super: {
        sherlock-launcher = super.sherlock-launcher.overrideAttrs (oldAttrs: rec {
              version = "0.1.13";
              src = pkgs.fetchFromGitHub {
                  owner = "Skxxtz";
                  repo = "sherlock";
                  tag = "v${version}";
                  hash = "sha256-HCSvWML/nWC4R+obkNvcKIcWRfNqqY13rowX9kN9sKk=";
              };
        });
    })];
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
