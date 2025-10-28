from pathlib import Path

from dasbus.connection import SessionMessageBus


__all__ = [
    'send_notify'
]


def send_notify(message: str) -> None:
    f = Path.home() / "picture" / "icon" / "network.png"
    icon = f"{f.absolute()}" if f.exists() else ""
    proxy = SessionMessageBus().get_proxy(
        "org.freedesktop.Notifications",
        "/org/freedesktop/Notifications"
    )
    proxy.Notify(
        "",
        0,
        icon,
        "rpcd",
        message,
        [],
        {},
        0
    )


# vim: ts=4 sw=4 sts=4 ft=python et:
