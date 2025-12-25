{ pkgs, lib, config, ... }:

with lib;
let
    inherit (builtins) fromJSON readFile toFile toJSON unsafeDiscardStringContext;
    cfg = config.security.tpm2;
    tctiCfg = cfg.tctiEnvironment;
    userHome = config.userHome;
in
{
    config = mkIf (cfg.enable && tctiCfg.enable) (
    let
        tctiOption =
            if tctiCfg.interface == "tabrmd" then
                tctiCfg.tabrmdConf
            else
                tctiCfg.deviceConf;
        pkg = pkgs.tpm2-tss;
        defaultCfgFile = pkg + /etc/tpm2-tss/fapi-config.json;
        defaultCfg = fromJSON (unsafeDiscardStringContext (readFile defaultCfgFile));
        fixedCfg = defaultCfg // {
            system_dir = "${userHome}/.local/share/tpm2-tss/system/keystore";
            log_dir = "${userHome}/.local/share/tpm2-tss/log";
            tcti = "${tctiCfg.interface}:${tctiOption}";
            profile_name = "P_RSA2048SHA256";
            ek_cert_less = "yes";
        };
        fixedCfgFile = toFile "fapi-config.json" (toJSON fixedCfg);
    in
    {
        environment.variables.TSS2_FAPICONF = fixedCfgFile;
    });
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
