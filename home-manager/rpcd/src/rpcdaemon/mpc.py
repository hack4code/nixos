import time
from pathlib import Path
from typing import Literal

from mpd import MPDClient

from .logger import logger


__all__ = [
    "play_mpd",
    "stop_mpd",
    "pause_mpd",
    "resume_mpd",
    "shuffle_mpd",
    "reload_mpd",
    "set_mpd_volume",
    "get_mpd_state"
]


mpd_state_pre = None


class MpcManager:
    def __init__(self):
        self.client = None

    def __enter__(self):
        client = MPDClient()
        client.timeout = 10
        client.idletimeout = None
        client.connect("localhost", 6600)
        self.client = client
        return self.client

    def __exit__(self, exc_type, exc_value, traceback):
        if exc_value is not None:
            logger.error(f"MpcManager:\n{exc_value}")
        if self.client is not None:
            self.client.close()
            self.client.disconnect()


def get_mpd_state() -> Literal["playing", "paused", "stopped"]:
    with MpcManager() as mp:
        state = mp.status()["state"]
    match state:
        case "play":
            return "playing"

        case "pause":
            return "paused"

        case "stop":
            return "stopped"

        case _:
            return "paused"


def set_mpd_volume(volume: int) -> None:
    with MpcManager() as mp:
        mp.setvol(volume)


def start_mpd() -> None:
    with MpcManager() as mp:
        mp.play(0)


def play_mpd() -> None:
    with MpcManager() as mp:
        mp.pause(0)


def stop_mpd() -> None:
    with MpcManager() as mp:
        mp.pause(1)


def shuffle_mpd() -> None:
    with MpcManager() as mp:
        mp.shuffle()


def pause_mpd() -> None:
    state = get_mpd_state()
    if state == "paused":
        return
    if state == "playing":
        global mpd_state_pre
        mpd_state_pre = state
        stop_mpd()


def resume_mpd() -> bool:
    match mpd_state_pre:
        case "playing":
            play_mpd()
            return True

        case _:
            return False


def toggle_mpd() -> None:
    global mpd_state_pre

    match get_mpd_state():
        case "playing":
            mpd_state_pre = "paused"
            stop_mpd()

        case "paused":
            mpd_state_pre = "playing"
            play_mpd()

        case "stopped":
            mpd_state_pre = "playing"
            start_mpd()


def reload_mpd() -> None:
    song = Path.home() / "music" / "song"
    if not song.exists():
        raise OSError(2, "song directory not exists")
    with MpcManager() as mp:
        mp.stop()
        mp.clear()
        mp.rescan()
        time.sleep(2)
        for f in song.iterdir():
            if not f.is_file():
                continue
            if f.suffix in (".mp3", ".m4a"):
                mp.add(f.name)
        mp.random(1)
        mp.repeat(1)
        mp.shuffle()


# vim: ts=4 sw=4 sts=4 ft=python et:
