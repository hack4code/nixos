import sys
import logging
import subprocess

import requests
from transmission_rpc import Client


def is_nfs_mounted():
    proc = subprocess.Popen(
        ["mount", "-l", "-t", "nfs4"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out, _ = proc.communicate()
    if out.find("/download") == -1:
        return False
    else:
        return True


logging.basicConfig(format='%(asctime)s %(message)s')
client = Client(host="10.0.0.1", port=9091)
torrents = client.get_torrents()
enable_download = False
for torrent in torrents:
    if torrent.progress == 100:
        enable_download = True
        logging.info(f"{torrent.name} finished")
        client.remove_torrent(torrent.id)


if enable_download:
    if is_nfs_mounted():
        try:
            requests.post(
                "http://10.0.0.2:8080/notify",
                json={'message': 'transmission finished movies downloading'}
            )
        except Exception:
            logging.error("connect 10.0.0.2 error")
    else:
        try:
            r = requests.get("http://10.0.0.2:8080/transmission/download")
        except Exception:
            logging.error("connect 10.0.0.2 error")
            sys.exit(-1)
        success = r.json().get("status")
        if success == "success":
            logging.info("start downloading movie")
        else:
            logging.warning("failed to start downloading movie")


# vim: ts=4 sw=4 sts=4 ft=python et:
