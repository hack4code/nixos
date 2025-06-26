from pathlib import Path
from multiprocessing import Process

import yt_dlp

from .sway import move_mpv_to_workspace
from .mpv import play_youtube_video_with_mpv


__all__ = [
    "download_song_from_youtube",
    "download_video_from_youtube",
    "play_video_from_youtube"
]


def _get_youtube_path() -> Path:
    path = Path.home() / "music" / "youtube"
    if not path.exists():
        raise OSError(2, "directory youtube not exists")
    return path


def download_song_from_youtube(url: str) -> None:
    path = _get_youtube_path()
    options = {
        'quiet': True,
        'noplaylist': True,
        'keepvideo': False,
        'restrictfilenames': True,
        'cookiesfrombrowser': ('firefox', None, None, 'self'),
        'format': 'm4a/bestaudio/best',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'm4a',
        }],
        'paths': {
            'home': str(path.absolute())
        },
        'outtmpl': {
            'default': '%(title)s.%(ext)s'
        }
    }
    with yt_dlp.YoutubeDL(options) as ydl:
        ydl.download([url])


def download_video_from_youtube(url: str) -> None:
    path = _get_youtube_path()
    options = {
        'quiet': True,
        'noplaylist': True,
        'restrictfilenames': True,
        'writesubtitles': True,
        'subtitleslangs': ['^en.*'],
        'cookiesfrombrowser': ('firefox', None, None, 'self'),
        'format': 'bestvideo[height<=?1080]+bestaudio/best',
        'paths': {
            'home': str(path.absolute())
        },
        'outtmpl': {
            'default': '%(title)s.%(ext)s'
        }
    }
    with yt_dlp.YoutubeDL(options) as ydl:
        ydl.download([url])


def play_video_from_youtube(url: str) -> None:
    play_youtube_video_with_mpv(url)
    proc = Process(target=move_mpv_to_workspace, args=[False])
    proc.start()
    proc.join()


# vim: ts=4 sw=4 sts=4 ft=python et:
