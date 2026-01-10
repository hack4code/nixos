from dasbus.connection import SessionMessageBus


__all__ = [
    'send_notify'
]


def send_notify(message: str, icon: str = "preferences-desktop-notification-bell") -> None:
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
