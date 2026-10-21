{ pkgs, nixOSVersion, ... }:

{
    services.fwupd = {
        enable = true;

        uefiCapsuleSettings = {
            DisableShimForSecureBoot = true;
        };
    } // (if nixOSVersion == "26.05" then {
        package = pkgs.fwupd.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace meson.build \
                  --replace-fail \
                  "efi_app_location = join_paths(dependency('fwupd-efi').get_variable(pkgconfig: 'prefix'), 'libexec', 'fwupd', 'efi')" \
                  "efi_app_location = '/run/fwupd-efi'"
            '';
        });
    }
    else {
    });
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
