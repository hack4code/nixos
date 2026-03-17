from subprocess import CalledProcessError

from pydantic import (
    BaseModel,
    HttpUrl
)
from fastapi import (
    FastAPI,
    Request,
    HTTPException,
    BackgroundTasks
)
from fastapi.responses import JSONResponse

from .mpc import reload_mpd
from .notify import send_notify
from .firefox import open_url_remote
from .youtube import (
    download_song_from_youtube,
    download_video_from_youtube,
    play_video_from_youtube
)
from .transmission import (
    download_movie_from_vps,
    add_torrent_to_transmission,
    TransmissionError
)
from .rtorrent import (
    JSONRpcError,
    add_torrent_to_rtorrent
)
from .sway import (
    set_ncmpcpp_fullscreen,
    set_ncmpcpp_display_time,
    set_ncmpcpp_display_visualizer,
    set_ncmpcpp_display_lyrics,
    set_ncmpcpp_lyrics_down,
    set_ncmpcpp_lyrics_up,
    set_ncmpcpp_toggle,
    set_ncmpcpp_toggle_fullscreen,
    set_container_fullscreen,
    set_container_disable_fullscreen,
    set_container_toggle_fullscreen,
    resume_ncmpcpp,
    resume_system,
    idle_system,
    sleep_system,
    shutdown_system,
    launch_floating_kitty,
    toggle_btop,
    SwayIpcError
)
from .mpv import (
    setup_for_mpv_open,
    setup_for_mpv_shutdown,
    setup_for_mpv_play,
    setup_for_mpv_pause,
)
from .logger import logger


__all__ = [
    "app"
]


class Message(BaseModel):
    title: str = "rpcd"
    message: str
    icon: str


class Youtube(BaseModel):
    url: HttpUrl


class Mpv(BaseModel):
    file_name: str


class Transmission(BaseModel):
    magnet: str


class RTorrent(BaseModel):
    magnet: str


class Fullscreen(BaseModel):
    app_id: str


app = FastAPI(title="rpcd", description="rpc daemon")


@app.exception_handler(HTTPException)
def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "status": "error",
            "detail": exc.detail
        }
    )


@app.exception_handler(CalledProcessError)
def subprocess_calledprocesserror_handler(request: Request,
                                         exc: CalledProcessError):
    logger.error(f"CalledProcessError:\n{exc.stderr.decode('utf-8')}")
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "detail": "subprocess exception"
        }
    )


@app.exception_handler(OSError)
def subprocess_oserror_handler(request: Request, exc: OSError):
    logger.error(f"OSError:\n{exc}")
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "detail": "OSError"
        }
    )


@app.exception_handler(SwayIpcError)
def subprocess_swayipcerror_handler(request: Request, exc: SwayIpcError):
    logger.error(f"SwayIpcError[{exc.func}]:\n{exc.msg}")
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "detail": "SwayIpcError"
        }
    )


@app.exception_handler(JSONRpcError)
def jsonrpcerror_handler(request: Request, exc: JSONRpcError):
    logger.error(f"JSONRpcError:h[code={exc.code}]:\n{exc.message}")
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "detail": "JSONRpcError"
        }
    )


@app.exception_handler(TransmissionError)
def transmissionerror_handler(request: Request, exc: TransmissionError):
    logger.error(
        f"add_torrent_to_transmission[status_code={exc.status_code}]:\n{exc.msg}"
    )
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "detail": "TransmissionError"
        }
    )


@app.post("/notify")
def notify(msg: Message):
    send_notify(
        message=msg.message,
        icon=msg.icon,
        title=msg.title
    )
    return {"status": "success"}


@app.post("/youtube/download/song")
def youtube_download_song(video: Youtube, tasks: BackgroundTasks):
    def download(url: str) -> None:
        try:
            download_song_from_youtube(url)
        except Exception:
            logger.exception("download_song_from_youtube:\n")
            send_notify(
                message="download song from youtube failed",
                icon="youtube-music",
                title="rpcd"
            )
        else:
            send_notify(
                message="finished song downloading from youtube",
                icon="youtube-music",
                title="rpcd"
            )

    url = str(video.url)
    logger.info(f"download song from youtube[{url}]")
    tasks.add_task(download, url)
    return {"status": "success"}


@app.post("/youtube/download/video")
def youtube_download_video(video: Youtube, tasks: BackgroundTasks):
    def download(url: str) -> None:
        try:
            download_video_from_youtube(url)
        except Exception:
            logger.exception("download_video_from_youtube:\n")
            send_notify(
                message="download video from youtube failed",
                icon="youtube",
                title="rpcd"
            )
        else:
            send_notify(
                message="finished video downloading from youtube",
                icon="youtube",
                title="rpcd"
            )

    url = str(video.url)
    tasks.add_task(download, url)
    return {"status": "success"}


@app.post("/youtube/play/video")
def youtube_play_video(video: Youtube, tasks: BackgroundTasks):
    def play(url: str) -> None:
        try:
            play_video_from_youtube(url)
        except CalledProcessError as err:
            logger.error(
                f"play_video_from_youtube:\n{err.stderr.decode('utf-8')}"
            )
        except SwayIpcError as err:
            logger.error(f"{err.func}:\n{err.msg}")
        except Exception:
            logger.exception("play_video_from_youtube:\n")

    url = str(video.url)
    tasks.add_task(play, url)
    return {"status": "success"}


@app.get("/transmission/download")
def transmission_download_movie(tasks: BackgroundTasks):
    def download() -> None:
        logger.info("downloading movies from vps")
        try:
            download_movie_from_vps()
        except CalledProcessError as err:
            logger.error(
                f"download_movie_from_vps:\n{err.stderr.decode('utf-8')}"
            )
        except OSError as err:
            logger.error(f"download_movie_from_vps:\n{err}")
        except Exception:
            logger.exception("download_movie_from_vps:\n")

    tasks.add_task(download)
    return {"status": "success"}


@app.post("/transmission/torrent")
def transmission_add_torrent(transmission: Transmission):
    magnet = transmission.magnet
    logger.info(f"torrent [{magnet}]")
    add_torrent_to_transmission(magnet)
    open_url_remote("http://10.0.0.1:9091/transmission/web/")
    return {"status": "success"}


@app.post("/rtorrent/torrent")
def rtorrent_add_torrent(rtorrent: RTorrent):
    magnet = rtorrent.magnet
    logger.info(f"torrent [{magnet}]")
    add_torrent_to_rtorrent(magnet)
    return {"status": "success"}


@app.get("/mpv/shutdown")
def mpv_shutdown():
    setup_for_mpv_shutdown()
    return {"status": "success"}


@app.post("/mpv/open")
def mpv_open(mpv: Mpv, tasks: BackgroundTasks):
    def setup_for_open(fn, focus):
        try:
            setup_for_mpv_open(fn, focus=focus)
        except SwayIpcError as exc:
            logger.error(f"SwayIpcError[{exc.func}]:\n{exc.msg}")
        except Exception:
            logger.exception("setup_workspace_for_mpv_playing:\n")

    file_name = mpv.file_name
    if file_name.startswith("https://"):
        tasks.add_task(setup_for_open, file_name, False)
    else:
        tasks.add_task(setup_for_open, file_name, True)
    return {"status": "success"}


@app.get("/mpv/state/{state}")
def mpv_state(state: str, tasks: BackgroundTasks):
    match state:
        case "play":
            tasks.add_task(setup_for_mpv_play)

        case "pause":
            setup_for_mpv_pause()

    return {"status": "success"}


@app.get("/ncmpcpp/{command}")
def ncmpcpp_command(command: str):
    match command:
        case "fullscreen":
            set_ncmpcpp_fullscreen(True)

        case "visualizer":
            set_ncmpcpp_display_visualizer()

        case "time":
            set_ncmpcpp_display_time()

        case "togglefullscreen":
            set_ncmpcpp_toggle_fullscreen()

        case "lyrics":
            set_ncmpcpp_display_lyrics()

        case "lyricsdown":
            set_ncmpcpp_lyrics_down()

        case "lyricsup":
            set_ncmpcpp_lyrics_up()

        case "toggle":
            set_ncmpcpp_toggle()

        case "resume":
            resume_ncmpcpp()

    return {"status": "success"}


@app.get("/mpd/reload")
def mpd_reload(tasks: BackgroundTasks):
    def reload():
        try:
            reload_mpd()
        except Exception:
            logger.exception("reload_mpd:\n")

    tasks.add_task(reload)
    return {"status": "success"}


@app.post("/system/fullscreen/toggle")
def system_fullscreen_toggle(fs: Fullscreen):
    app_id = fs.app_id
    set_container_toggle_fullscreen(app_id)
    return {"status": "success"}


@app.post("/system/fullscreen/enable")
def system_fullscreen_enable(fs: Fullscreen):
    app_id = fs.app_id
    set_container_fullscreen(app_id, True)
    return {"status": "success"}


@app.post("/system/fullscreen/disable")
def system_fullscreen_disable(fs: Fullscreen):
    app_id = fs.app_id
    set_container_disable_fullscreen(app_id)
    return {"status": "success"}


@app.get("/system/idle")
def system_idle():
    idle_system()
    return {"status": "success"}


@app.get("/system/resume")
def system_resume(tasks: BackgroundTasks):
    def resume():
        try:
            resume_system()
        except SwayIpcError as exc:
            logger.error(f"SwayIpcError[{exc.func}]:\n{exc.msg}")
        except Exception:
            logger.exception("resume_system:\n")

    tasks.add_task(resume)
    return {"status": "success"}


@app.get("/system/sleep")
def system_sleep():
    sleep_system()
    return {"status": "success"}


@app.get("/system/shutdown")
def system_shutdown():
    shutdown_system()
    return {"status": "success"}


@app.get("/system/launch/floatingkitty")
def system_launch_kitty():
    launch_floating_kitty()
    return {"status": "success"}


@app.get("/system/toggle/btop")
def system_toggle_btop():
    toggle_btop()
    return {"status": "success"}


# vim: ts=4 sw=4 sts=4 ft=python et:
