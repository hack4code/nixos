import signal

from dasbus.loop import EventLoop
from dasbus.connection import SessionMessageBus

from .sway import set_ncmpcpp_for_playing
from .mpc import (
    pause_mpd,
    resume_mpd
)


__all__ = [
    "catch_firefox_signal",
    "open_url_remote"
]


urls_played = set()
firefox_dbus_name = None


def find_dubs_name(start: str) -> str | None:
    proxy = SessionMessageBus().get_proxy(
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus"
    )
    return next(
        (name for name in proxy.ListNames() if name.startswith(start)),
        None
    )


def PropertiesChanged(interface_name: str,
                      changed_properties: dict,
                      invalidated_properties: dict) -> None:

    match changed_properties:
        case {"Metadata": properties}:
            try:
                title = properties["xesam:title"]
                url = properties["xesam:url"]
            except KeyError:
                pass
            else:
                if not url or not title:
                    return
                if url not in urls_played:
                    urls_played.add(url)
                    pause_mpd()

        case {"PlaybackStatus": status}:
            match status.get_string():
                case "Playing":
                    pause_mpd()

                case "Paused" | "Stopped":
                    if resume_mpd():
                        set_ncmpcpp_for_playing()


def catch_signal(name: str) -> None:
    proxy = SessionMessageBus().get_proxy(name, "/org/mpris/MediaPlayer2")
    proxy.PropertiesChanged.connect(PropertiesChanged)


def NameOwnerChanged(name: str, owner_old: str, owner_new: str) -> None:
    global firefox_dbus_name

    if not name.startswith("org.mpris.MediaPlayer2.firefox"):
        return
    if owner_old:
        return
    if owner_new:
        urls_played.clear()
        if name != firefox_dbus_name:
            catch_signal(name)
            firefox_dbus_name = name


def setup_mpris_signal() -> None:
    global firefox_dbus_name

    if (name := find_dubs_name("org.mpris.MediaPlayer2.firefox")) is not None:
        firefox_dbus_name = name
        catch_signal(name)
    proxy = SessionMessageBus().get_proxy(
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus"
    )
    proxy.NameOwnerChanged.connect(NameOwnerChanged)


def catch_firefox_signal(*args, **kwargs) -> None:
    loop = EventLoop()

    def catch(signum, frame) -> None:
        match signum:
            case signal.SIGINT | signal.SIGTERM:
                loop.quit()

    signal.signal(signal.SIGINT, catch)
    signal.signal(signal.SIGTERM, catch)

    setup_mpris_signal()
    loop.run()


def open_url_remote(url: str) -> None:
    if (name := find_dubs_name("org.mozilla.firefox")) is None:
        return
    proxy = SessionMessageBus().get_proxy(name, "/org/mozilla/firefox/Remote")
    proxy.OpenURL(
        b''.join(
            [b'\x02\x00\x00\x00\x0d\x00\x00\x00\x0e\x00\x00\x00\x00\x00',
             url.encode("utf-8"),
             b'\x00']
        )
    )


# vim: ts=4 sw=4 sts=4 ft=python et:
