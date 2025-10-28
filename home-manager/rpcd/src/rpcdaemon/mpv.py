import shlex
import subprocess

from .mpc import (
    pause_mpd,
    resume_mpd,
    get_mpd_state
)
from .sway import (
    set_ncmpcpp_for_mpv,
    set_ncmpcpp_for_playing,
    move_mpv_to_workspace
)
from .logger import logger


__all__ = [
    "move_mpv_to_workspace",
    "setup_for_mpv_open",
    "setup_for_mpv_shutdown",
    "setup_for_mpv_play",
    "setup_for_mpv_pause",
    "play_youtube_video_with_mpv"
]



def setup_for_mpv_open(file_name: str, *, focus: bool = True) -> None:
    file_name = file_name.strip()
    logger.info(f"watching {file_name}")
    move_mpv_to_workspace(focus=focus)


def setup_for_mpv_shutdown() -> None:
    if resume_mpd():
        set_ncmpcpp_for_playing()


def setup_for_mpv_play() -> None:
    if get_mpd_state() == "playing":
        pause_mpd()
    set_ncmpcpp_for_mpv()


def setup_for_mpv_pause() -> None:
    pass


def play_youtube_video_with_mpv(url: str, *, sub: bool = True) -> None:
    if sub:
        options_ytdlp = (
            "sub-langs=\"^en.*\",sub-format=best,"
            "write-subs=,write-auto-subs="
        )
    else:
        options_ytdlp = "no-write-subs=,no-write-auto-subs="
    command = (
        "mpv "
        "--terminal=yes "
        "--sub-font='Roboto,MiSans' "
        "--sub-font-size=42 "
        "--sub-border-size=1 "
        "--force-window=immediate "
        "--sub-color='#d79921' "
        "--sub-pos=64 "
        "--sub-shadow-color='0.0/0.0/0.0/0.8' "
        "--sub-shadow-offset=1 "
        "--sub-line-spacing=8 "
        "--osd-color='#fe8019' "
        "--cache=yes "
        "--demuxer-max-bytes=1024MiB "
        "--demuxer-readahead-secs=60 "
        "--ytdl-format='bestvideo[height<=?1080]+bestaudio/best' "
        "--ytdl-raw-options='ignore-config=,"
        "cookies-from-browser=\"firefox::self\",mark-watched=,"
        f"{options_ytdlp}' "
        f"'{url}'"
    )
    subprocess.Popen(
        shlex.split(command),
        stdin=None,
        stdout=None,
        stderr=None,
        close_fds=True
    )


# vim: ts=4 sw=4 sts=4 ft=python et:
