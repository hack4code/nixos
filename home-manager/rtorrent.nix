{ config, pkgs, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
    vpsIp4Address = config.vpsIp4Address;
    rtorrentConfigDir = "${userHome}/.config/rtorrent";
    rtorrentDownloadDir = "${userHome}/download/.rtorrent";
    rtorrentDataDir = "${userHome}/.local/share/rtorrent";
in
{
    home-manager.users.${userName} = {
        programs.rtorrent = {
            enable = true;

            extraConfig = ''
                ip = ${vpsIp4Address}

                network.port_range.set = 50000-50000
                network.port_random.set = no

                dht.mode.set = auto
                dht.override_port.set = 6881
                protocol.pex.set = yes
                trackers.use_udp.set = yes

                ratio.enable = true
                ratio.min.set = 100
                ratio.max.set = 300
                ratio.upload.set = 2M
                method.set = group.seeding.ratio.command, "d.close= ; d.erase="

                throttle.up = slowupload,100
                throttle.max_uploads.set = 100
                throttle.max_uploads.global.set = 250

                throttle.min_peers.normal.set = 20
                throttle.max_peers.normal.set = 60
                throttle.min_peers.seed.set = 30
                throttle.max_peers.seed.set = 80
                trackers.numwant.set = 80

                method.insert = cfg.basedir,  private|const|string, (cat,"${rtorrentConfigDir}/")
                method.insert = cfg.download, private|const|string, (cat,"${rtorrentDownloadDir}/", "downloading/")
                method.insert = cfg.logs,     private|const|string, (cat,"${rtorrentDataDir}/","log/")
                method.insert = cfg.logfile,  private|const|string, (cat,(cfg.logs),"rtorrent-",(system.time),".log")
                method.insert = cfg.session,  private|const|string, (cat,"${rtorrentDataDir}/","session/")
                method.insert = cfg.watch,    private|const|string, (cat,"${rtorrentDownloadDir}/","watch/")

                execute.throw = sh, -c, (cat, "mkdir -p \"",(cfg.download),"\" ", "\"",(cfg.logs),"\" ", "\"",(cfg.session),"\" ", "\"",(cfg.watch),"/load\" ", "\"",(cfg.watch),"/start\" ")

                protocol.encryption.set = allow_incoming,try_outgoing,enable_retry

                network.http.max_open.set = 50
                network.max_open_files.set = 600
                network.max_open_sockets.set = 300

                pieces.memory.max.set = 1800M

                session.path.set = (cat, (cfg.session))
                directory.default.set = (cat, (cfg.download))
                log.execute = (cat, (cfg.logs), "execute.log")
                log.xmlrpc = (cat, (cfg.logs), "rpc.log")
                execute.nothrow = sh, -c, (cat, "echo >", (session.path), "rtorrent.pid", " ",(system.pid))

                encoding.add = UTF-8
                system.umask.set = 0027
                system.cwd.set = (directory.default)
                network.http.dns_cache_timeout.set = 25
                schedule2 = monitor_diskspace, 15, 60, ((close_low_diskspace, 1000M))
                pieces.hash.on_completion.set = yes
                view.sort_current = seeding, greater=d.ratio=
                keys.layout.set = qwerty

                network.rpc.use_xmlrpc.set = false
                network.rpc.use_jsonrpc.set = true

                method.insert = system.startup_time, value|const, (system.time)
                method.insert = d.data_path, simple, "if=(d.is_multi_file), (cat, (d.directory), /), (cat, (d.directory), /, (d.name))"
                method.insert = d.session_file, simple, "cat=(session.path), (d.hash), .torrent"

                schedule2 = watch_load, 11, 10, ((load.verbose, (cat, (cfg.watch), "load/*.torrent")))
                schedule2 = watch_start, 10, 10, ((load.start_verbose, (cat, (cfg.watch), "start/*.torrent")))

                # system.daemon.set = true
                network.scgi.open_local = (cat,(session.path),rpc.socket)
                execute.nothrow = chmod,770,(cat,(session.path),rpc.socket)

                print = (cat, "Logging to ", (cfg.logfile))
                log.open_file = "log", (cfg.logfile)
                log.add_output = "info", "log"

                # notify
                method.insert = d.notify_message, simple, "cat=$d.name=, \": finished downloading\""
                method.set_key = event.download.finished,notify_me,"execute2=${pkgs.libnotify}/bin/notify-send,--icon=media-downloader,rtorrent,$d.notify_message="

                # move finished data to download
                method.insert = d.get_finished_dir, simple, "cat=~/download/,$d.custom1="
                method.insert = d.move_to_complete, simple, "d.directory.set=$argument.1=; execute=mkdir,-p,$argument.1=; execute=mv,-u,$argument.0=,$argument.1=; d.save_full_session="
                method.set_key = event.download.finished,move_complete,"d.move_to_complete=$d.data_path=,$d.get_finished_dir="

                # remove torrent after finishing
                method.set_key = event.download.finished,rm_torrent,"execute2=rm,$d.get_tied_to_file="

                # color
                ui.color.title.set = "141 on 237"
                ui.color.footer.set = "141 on 237"
                ui.color.focus.set = "reverse"
                ui.color.label.set = ""
                ui.color.complete.set = "green"
                ui.color.seeding.set = "blue"
                ui.color.stopped.set = "red"
                ui.color.leeching.set = "cyan"
                ui.color.queued.set = "yellow"
                ui.color.incomplete.set = "yellow"
                ui.color.odd.set = "bold"
                ui.color.even.set = "red"
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
