#!/usr/bin/env python


import sys
import shlex
import subprocess

import httpx


def is_image(url: str) -> bool:
    exts = [ '.svg', '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp' ]
    for ext in exts:
        if url.endswith(ext):
            return True

    try:
        headers = httpx.head(url).headers
    except Exception:
        return False

    try:
        if 'image' in headers['content-type'].lower():
            return True
    except KeyError:
        return False

    return False


def open_url_with_firefox(url: str) -> None:
    command = (
        'firefox '
        '--new-tab '
        f"'{url}'"
    )
    subprocess.Popen(
        shlex.split(command),
        stdin=None,
        stdout=None,
        stderr=None,
        close_fds=True
    )


def open_url_with_swayimg(url: str) -> None:
    command = (
        'swayimg '
        f'"exec://curl -s -o - \'{url}\'"'
    )
    subprocess.Popen(
        shlex.split(command),
        stdin=None,
        stdout=None,
        stderr=None,
        close_fds=True
    )


if __name__ == "__main__":
    url = sys.argv[1].strip(' \n\r').lower()
    if is_image(url):
        open_url_with_swayimg(url)
    else:
        open_url_with_firefox(url)
