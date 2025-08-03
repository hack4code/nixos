{ lib, ... }:

{
    options = with lib; with types; {
        keyboard = mkOption { type = str; };
        cherry = mkOption { type = str; };
        touchpad = mkOption { type = str; };
        trackpoint = mkOption { type = str; };
    };

    config = {
        keyboard = "1:1:AT_Translated_Set_2_keyboard";
        cherry = "1671:10:MX-LP_2.1-BT1_Keyboard";
        touchpad = "1267:12624:ELAN0670:00_04F3:3150_Touchpad";
        trackpoint = "2:10:TPPS/2_Elan_TrackPoint";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
