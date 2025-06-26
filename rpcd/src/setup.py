#!env python


from setuptools import setup, find_packages


setup(
    name='rpcdaemon',
    version='1.0',
    description='rpc daemon',
    packages=find_packages(),
    scripts=["rpcd"],
    install_requires=[
        'fastapi',
        'dasbus',
        'httpx',
        'uvicorn',
        'yt-dlp',
        'i3ipc'
        'mpd2'
        'systemd'
    ]
)


# vim: ts=4 sw=4 sts=4 ft=python et:
