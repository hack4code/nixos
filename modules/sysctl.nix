{
    boot.kernel.sysctl = {
        /* net */
        "net.core.bpf_jit_harden" = 2;
        "net.core.busy_read" = 0;
        "net.core.default_qdisc" = "fq_codel";
        "net.core.dev_weight" = 256;
        "net.core.netdev_budget" = 800;
        "net.core.netdev_budget_usecs" = 5000;
        "net.core.netdev_max_backlog" = 16384;
        "net.core.netdev_tstamp_prequeue" = 0;
        "net.core.rmem_default" = 8388608;
        "net.core.rmem_max" = 16777216;
        "net.core.somaxconn" = 2048;
        "net.core.wmem_default" = 8388608;
        "net.core.wmem_max" = 16777216;

        /* ip */
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.ip_no_pmtu_disc" = "3";
        "net.ipv4.ip_forward" = "1";
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.all.use_tempaddr" = "2";

        /* tcp */
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
        "net.ipv4.tcp_mtu_probing" = "1";
        "net.ipv4.tcp_fin_timeout" = "15";
        "net.ipv4.tcp_ecn" = "1";
        "net.ipv4.tcp_frto" = "2";
        "net.ipv4.tcp_recovery" = "1";
        "net.ipv4.tcp_low_latency" = "1";
        "net.ipv4.tcp_synack_retries" = "3";
        "net.ipv4.tcp_congestion_control" = "bbr";

        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
        "kernel.perf_event_paranoid" = 3;
        "kernel.randomize_va_space" = 2;
        "kernel.yama.ptrace_scope" = 3;
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.warn_limit" = 1;
        "kernel.oops_limit" = 1;
        "kernel.threads-max" = 1073741823;
        "kernel.split_lock_mitigate" = 0;

        "dev.tty.ldisc_autoload" = 0;
        "dev.tty.legacy_tiocsti" = 0;

        "vm.unprivileged_userfaultfd" = 0;
        "vm.swappiness" = 150;
        "vm.max_map_count" = 2147483642;
        "vm.vfs_cache_pressure" = 50;
        "vm.compaction_proactiveness" = 40;
        "vm.watermark_scale_factor" = 500;
        "vm.watermark_boost_factor" = 15000;
        "vm.defrag_mode" = 0;
        "vm.overcommit_memory" = 1;
        "vm.dirty_writeback_centisecs" = 100;

        "fs.protected_symlinks" = 1;
        "fs.protected_hardlinks" = 1;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
        "fs.suid_dumpable" = 0;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
