import logging

from systemd.journal import JournalHandler


__all__ = [
    'add_systemd_handler'
]


def add_systemd_handler(logger):
    handler = JournalHandler(SYSLOG_IDENTIFIER="rpcd")
    handler.setFormatter(logging.Formatter(fmt="%(message)s"))
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)


# vim: ts=4 sw=4 sts=4 ft=python et :
