{config, lib, ...}:
let
    weechatUserName = config.weechatUserName;
    weechatNickNames = config.weechatNickNames;
    liberaChannels = config.liberaChannels;
    liberaUserName = config.liberaUserName;
    liberaPassword = config.liberaPassword;
    oftcChannels = config.oftcChannels;
    oftcPassword = config.oftcPassword;
    oftcUserName = config.oftcUserName;
in
{
    nixpkgs.config.packageOverrides = pkgs: {
        weechat = pkgs.weechat.override {
            configure = { ... }: {
                scripts = with pkgs.weechatScripts; [
                    autosort
                    buffer_autoset
                    colorize_nicks
                    url_hint
                ];

                init =
                let
                    libera_channels =  lib.strings.concatStringsSep "," liberaChannels;
                    oftc_channels = lib.strings.concatStringsSep "," oftcChannels;
                    nick_names = lib.strings.concatStringsSep "," weechatNickNames;
                in
                ''
                    /set irc.server_default.username "${weechatUserName}"
                    /server addreplace oftc irc.oftc.net/6697 -autoconnect
                    /server addreplace libera irc.libera.chat/6697 -autoconnect

                    /set irc.server.libera.command "/msg NickServ IDENTIFY ${liberaUserName} ${liberaPassword}"
                    /set irc.server.libera.autojoin_delay 8
                    /set irc.server.libera.command_delay 0
                    /set irc.server.libera.autojoin "${libera_channels}"
                    /set irc.server.libera.nicks "${nick_names}"

                    /set irc.server.oftc.command "/msg NickServ IDENTIFY ${oftcPassword} ${oftcUserName}"
                    /set irc.server.oftc.autojoin_delay 4
                    /set irc.server.oftc.autojoin "${oftc_channels}"
                    /set irc.server.oftc.nicks "${nick_names}"

                    /bar hide nicklist

                    /key unbind ctrl-q
                    /key bind ctrl-q /quit
                    /key unbind ctrl-j
                    /key bind ctrl-j /buffer +1\;/window refresh
                    /key unbind ctrl-k
                    /key bind ctrl-k /buffer -1\;/window refresh
                    /key unbind meta-s
                    /key bind meta-s /go
                    /key unbind ctrl-d
                    /key bind ctrl-d /window scroll_down
                    /key unbind ctrl-u
                    /key bind ctrl-u /window scroll_up
                    /key unbind ctrl-n
                    /key bind ctrl-n /buffer jump smart\;/window refresh
                    /key unbind ctrl-c
                    /key bind ctrl-c /input delete_beginning_of_line

                    /set weechat.color.separator black
                    /set weechat.bar.title.color_bg default
                    /set weechat.bar.title.size 2
                    /set weechat.bar.title.separator on
                    /set logger.look.backlog 0

                    /trigger addreplace msg_disconnect modifier weechat_print "\''${tg_message_nocolor} =~ ^irc: disconnected from server$" "/(.*)/\''${color:red}^-_-^\''${color:reset}" ""

                    /set irc.look.server_buffer independent
                    /set weechat.bar.buflist.size 30

                    /buffer_autoset add irc.libera.NickServ hidden 1

                    /alias addreplace open_url /url_hint_replace /exec -bg open_url_from_kitty.py {url\$1}
                    /key unbind f1
                    /key bind f1 /open_url 1
                    /key unbind f2
                    /key bind f2 /open_url 2
                    /key unbind f3
                    /key bind f3 /open_url 3
                    /key unbind f4
                    /key bind f4 /open_url 4
                    /key unbind f5
                    /key bind f5 /open_url 5
                    /key unbind f6
                    /key bind f6 /open_url 6
                    /key unbind f7
                    /key bind f7 /open_url 7
                    /key unbind f8
                    /key bind f8 /open_url 8
                    /key unbind f9
                    /key bind f9 /open_url 9

                    /set buflist.format.buffer "\''${format_number}\''${indent}\''${format_nick_prefix}\''${if:\''${current_buffer}?\''${color:lightgreen}:\''${color_hotlist}}\''${name}"
                    /set buflist.format.buffer_current "\''${color:green,default}\''${format_buffer}"
                    /set buflist.format.indent "\''${color:237}\''${if:\''${buffer.nextbuffer.localvariables.type}=~^(channel|private)\$?├─:└─}"
                    /script install go.py
                    /set plugins.var.python.go.color_name "white,default"
                    /set plugins.var.python.go.color_name_highlight "green,default"
                    /set plugins.var.python.go.color_name_highlight_selected "red,default"
                    /set plugins.var.python.go.color_name_selected "green,default"
                    /set plugins.var.python.go.color_number "yellow,magenta"
                    /set plugins.var.python.go.color_number_selected "yellow,red"
                    /set plugins.var.python.go.fuzzy_search "on"

                    /set plugins.var.python.url_hint.update_title "off"
                    /set weechat.look.window_title "\''${name}"
                '';
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
