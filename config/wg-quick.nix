{ lib, ... }:

{
    options = with lib; with types; {
        ip4AddressOfRule = mkOption { type = listOf str; };
        ip6AddressOfRule = mkOption { type = listOf str; };
    };

    config = {
        ip4AddressOfRule = [
            # tuna
            "101.6.15.130"
            "101.6.6.172"
            # ustc
            "111.186.58.212"
            "202.38.95.110"
            # douban
            "120.53.130.158"
            "140.143.177.206"
            "81.70.124.99"
            # zhihu
            "43.135.83.2"
            # api.linode.com
            "95.100.110.29"
            "95.100.110.14"
            # bilibili
            "148.153.34.154"
            "148.153.35.66"
            "103.151.151.133"
            "103.151.151.134"
        ];

        ip6AddressOfRule = [
            # tuna
            "2402:f000:1:400::2"
            "2402:f000:1:416:101:6:6:172"
            "2001:da8:d800:95::110"
            # api.linode.com
            "2a02:26f0:2780:70::215:ef0f"
            "2a02:26f0:2780:70::215:ef10"
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
