#!/usr/bin/env bash


DEST="$(dirname "$0")"

# shellcheck disable=SC1091
. "$DEST/bin/activate"
python "$DEST/torrent.py"
deactivate


# vim: ts=4 sw=4 sts=4 ft=bash et:
