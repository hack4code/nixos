#!/usr/bin/env python


from setuptools import setup, find_packages


setup(
    name='openurl',
    version='1.0',
    description='open url from kitty',
    packages=find_packages(),
    scripts=["open_url_from_kitty.py"],
    install_requires=[
        'httpx',
    ]
)


# vim: ts=4 sw=4 sts=4 ft=python et:
