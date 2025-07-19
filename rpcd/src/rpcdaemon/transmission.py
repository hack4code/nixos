import subprocess

import httpx


__all__ = [
    'download_movie_from_vps',
    'add_torrent_to_transmission'
]


TRANSMISSIONS_RPC_URL = "http://:@10.0.0.1:9091/transmission/rpc"


class TransmissionError(Exception):
    def __init__(self, code: int, msg: str):
        self.status_code = code
        self.msg = msg
        super().__init__(msg)


def download_movie_from_vps() -> None:
    subprocess.run(["downmovie.sh"], capture_output=True, check=True)


def add_torrent_to_transmission(magnet: str,
                                *,
                                session_id: str | None = None) -> None:
    if session_id is None:
        headers = {}
    else:
        headers = {"X-Transmission-Session-Id": session_id}
    data = {
        "arguments": {"filename": magnet},
        "method": "torrent-add"
    }
    r = httpx.post(
        TRANSMISSIONS_RPC_URL,
        headers=headers,
        json=data,
        timeout=8
    )
    match r.status_code:
        case 200:
            response = r.json()
            if response["result"] == "success":
                return
            raise TransmissionError(200, str(response))

        case 409:
            if session_id := r.headers["x-transmission-session-id"]:
                add_torrent_to_transmission(
                    magnet,
                    session_id=session_id
                )
                return
            raise TransmissionError(409, "no session_id found")

        case _ as code:
            raise TransmissionError(code, "error")


# vim: ts=4 sw=4 sts=4 ft=python et:
