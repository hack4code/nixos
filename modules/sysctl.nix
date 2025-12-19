{
    boot.kernel.sysctl = {
        /* ip */
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.ip_no_pmtu_disc" = "3";
        "net.ipv4.ip_forward" = "1";
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.all.use_tempaddr" = "2";

        /* net */
        "net.core.rmem_default" = 62914560;
        "net.core.wmem_default" = 62914560;
        "net.core.rmem_max" = 1006632960;
        "net.core.wmem_max" = 1006632960;
        "net.core.netdev_max_backlog" = 2000;
        "net.core.somaxconn" = 2048;
        "net.core.netdev_budget" = 1000;
        "net.core.netdev_tstamp_prequeue" = 0;
        "net.core.default_qdisc" = "fq";

        /* tcp */
        "net.ipv4.tcp_mem" = "65536 262144 1048576";
        "net.ipv4.tcp_rmem" = "1048576 62914560 503316480";
        "net.ipv4.tcp_wmem" = "1048576 62914560 503316480";
        "net.ipv4.tcp_moderate_rcvbuf" = "1";
        "net.ipv4.tcp_keepalive_time" = "7200";
        "net.ipv4.tcp_keepalive_intvl" = "180";
        "net.ipv4.tcp_keepalive_probes" = "32";
        "net.ipv4.tcp_slow_start_after_idle" = "0";
        "net.ipv4.tcp_sack" = "1";
        "net.ipv4.tcp_fack" = "1";
        "net.ipv4.tcp_timestamps" = "1";
        "net.ipv4.tcp_window_scaling" = "1";
        "net.ipv4.tcp_syncookies" = "1";
        "net.ipv4.tcp_mtu_probing" = "2";
        "net.ipv4.tcp_fin_timeout" = "15";
        "net.ipv4.tcp_ecn" = "1";
        "net.ipv4.tcp_frto" = "2";
        "net.ipv4.tcp_recovery" = "1";
        "net.ipv4.tcp_low_latency" = "1";
        "net.ipv4.tcp_synack_retries" = "3";
        "net.ipv4.tcp_congestion_control" = "bbr";

        /* udp */
        "net.ipv4.udp_mem" = "65536 262144 1048576";
        "net.ipv4.udp_rmem_min" = "31457280";
        "net.ipv4.udp_wmem_min" = "31457280";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
