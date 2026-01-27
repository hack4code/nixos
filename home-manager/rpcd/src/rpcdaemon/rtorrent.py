from typing import Iterator
from typing import Any
import json
import threading
import socket
import urllib.parse
from pathlib import Path


__all__ = [
    'add_torrent_to_rtorrent',
    'JSONRpcError'
]


NULL = b'\x00'
RTORRENT_DOWNLOAD_DIRECTORY = f'{Path.home()}/download/.rtorrent/'
RTORRENT_RPC_SOCK = f'{Path.home()}/.local/share/rtorrent/session/rpc.socket'


def encode_request(body: bytes, content_type: str | None = None) -> Iterator[bytes]:
    header_items: list[bytes] = [
        *(b'CONTENT_LENGTH', NULL, str(len(body)).encode(), NULL),
        *(b'SCGI', NULL, b'1', NULL),
    ]

    if content_type:
        header_items.extend((b'CONTENT_TYPE', NULL, content_type.encode(), NULL))

    header_len = sum(len(c) for c in header_items)

    yield str(header_len).encode()
    yield b':'
    yield from header_items
    yield b','
    yield body


def parse_raw_headers(raw: bytes) -> dict[str, str]:
    lines = raw.split(b'\r\n')
    d = {}
    for line in lines:
        key, value = line.split(b':')
        key = key.strip()
        d[key.decode().lower()] = value.strip().decode()
    return d


def parse_response(res: bytes) -> tuple[dict[str, str], bytes]:
    raw_header, _, body = res.partition(b'\r\n\r\n')
    h = parse_raw_headers(raw_header)
    assert int(h['content-length'].encode()) == len(body)
    return h, body


class SCGIUnixTransport:
    __path: str
    __timeout: float | None

    __slots__ = ('__path', '__timeout')

    def __init__(self, path: str, timeout: float | None) -> None:
        self.__path = path
        self.__timeout = timeout

    def _connect(self) -> socket.socket:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(self.__path)
        sock.settimeout(self.__timeout)
        return sock

    def request(self, body: bytes, content_type: str | None = None) -> bytes:
        with self._connect() as conn:
            for chunk in encode_request(body, content_type):
                conn.send(chunk)

            chunks = []
            while chunk := conn.recv(4096):
                chunks.append(chunk)

        _, res_body = parse_response(b''.join(chunks))
        return res_body


class JSONRpcError(Exception):
    code: int
    message: str
    data: Any
    id: int

    def __init__(self, code: int, message: str, data: Any, id: int):
        if data:
            super().__init__(code, message, data)
        else:
            super().__init__(code, message)
        self.code = code
        self.message = message
        self.data = data
        self.id = id


class JSONRpc:
    _id: int
    _lock: threading.Lock
    _transport: SCGIUnixTransport

    __slots__ = ('_id', '_lock', '_transport')

    def __init__(self, transport: SCGIUnixTransport):
        self._transport = transport

        self._id = 0
        self._lock = threading.Lock()

    def call(self, method: str, params: Any = []) -> Any:
        with self._lock:
            id = self._id
            self._id = (id + 1) % 1000000

        req = json.dumps(
            {'jsonrpc': '2.0', 'id': id, 'method': method, 'params': params}
        ).encode()

        res = self._transport.request(req, 'application/json')
        data = json.loads(res)

        assert data['id'] == id, "response.id doesn't match request.id"

        if 'error' in data:
            raise JSONRpcError(
                data['error']['code'],
                data['error']['message'],
                data['error'].get('data'),
                data['id'],
            )

        return data['result']


class RTorrent:
    def __init__(self, address: str = RTORRENT_RPC_SOCK, timeout: int = 5):
        p = urllib.parse.urlparse(address)
        transport = SCGIUnixTransport(p.path, timeout)
        self.jsonrpc = JSONRpc(transport)

    def add_magnet(self, magnet: str):
        params: list[str | bytes] = [
            '',
            f'd10:magnet-uri{len(magnet)}:{magnet}e',
            'd.tied_to_file.set=""',
            f'd.directory_base.set="{RTORRENT_DOWNLOAD_DIRECTORY}"',
            ''
        ]
        self.jsonrpc.call('load.raw_start_verbose', params)

    def download_list(self):
        params: list[str | bytes] = []
        return self.jsonrpc.call('download_list', params)


def add_torrent_to_rtorrent(magnet: str) -> None:
    r = RTorrent()
    r.add_magnet(magnet)


# vim: ts=4 sw=4 sts=4 ft=python et:
