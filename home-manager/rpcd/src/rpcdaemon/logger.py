import logging

from systemd.journal import JournalHandler


__all__ = [
    'logger',
    'init_systemd_logger'
]


logger = logging.getLogger(__name__)


def init_systemd_logger() -> None:
    handler = JournalHandler(SYSLOG_IDENTIFIER="rpcd")
    handler.setFormatter(logging.Formatter(fmt="%(message)s"))
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)


# vim: ts=4 sw=4 sts=4 ft=python et:
