{
    description = "A flake for MiSans fonts";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
    in
    {
        packages = {
            MiSans = pkgs.stdenv.mkDerivation {
                name = "misans";

                src = self;

                postInstall = ''
                    mkdir -p $out/share/fonts/
                    ${pkgs.findutils}/bin/find . -type d -name '*MiSans*' -exec cp -r {} $out/share/fonts/ \;
                '';

                meta = {
                    description = "MiSans fonts";
                };
            };
        };

        defaultPackage = self.packages.${system}.MiSans;

        devShells.default = pkgs.mkShell {
            buildInputs = [
                pkgs.fontconfig
                self.packages.${system}.MiSans
            ];
            shellHook = ''
                export FONTCONFIG_FILE=${pkgs.makeFontsConf {
                    fontDirectories = [ self.packages.${system}.MiSans ];
                }}
            '';
        };
    });
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
