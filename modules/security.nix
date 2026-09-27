{ pkgs, ... }:

{
    systemd.services.systemd-tpm2-setup.enable = false;

    security = {
        rtkit = {
            enable = true;
        };

        polkit = {
            enable = true;
        };

        tpm2 = {
            enable = true;

            pkcs11 = {
                enable = true;
            };

            fapi = {
                ekCertLess = true;
                profileName = "P_RSA2048SHA256";
            };
        };

        pam = {
            loginLimits = [
                {
                    domain = "*";
                    type = "-";
                    item = "memlock";
                    value = "unlimited";
                }

                {
                    domain = "*";
                    type = "-";
                    item = "nice";
                    value = "-20";
                }

                {
                    domain = "*";
                    type = "-";
                    item = "rtprio";
                    value = "unlimited";
                }
            ];

            services = {
                swaylock = {
                    enable = true;
                    name = "swaylock";
                    fprintAuth = true;
                    logFailures = false;
                    text = ''
                        auth sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so try_first_pass likeauth nullok
                        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_deny.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_unix.so
                    '';
                };

                login = {
                    unixAuth = true;
                    fprintAuth = false;
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
