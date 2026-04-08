from __future__ import absolute_import, division, print_function
from itertools import repeat

import ranger.api
from ranger.core.linemode import LinemodeBase


EXTENSIONS = {}
for extensions, icon in [
    ('py pyc', ''),
    ('cpp', ''),
    ('c h', '󰙱'),
    ('yml ini', '󱁻'),
    ('json', ''),
    ('toml', ''),
    ('xml', '󰗀'),
    ('pdf', ''),
    ('nix', ''),
    ('epub', ''),
    ('nsp', ''),
    ('md', ''),
    ('ass srt', ''),
    ('sh', ' '),
    ('csv', ''),
]:
    EXTENSIONS.update(dict(zip(extensions.split(), repeat(icon))))



@ranger.api.register_linemode
class MyLinemode(LinemodeBase):
    name = "unicode_icons"

    def filetitle(self, fobj, metadata):
        if fobj.is_directory:
            icon = ''
        elif fobj.extension in EXTENSIONS:
            icon = EXTENSIONS[fobj.extension]
        elif fobj.is_link:
            icon = ''
        elif fobj.audio:
            icon = '󰎅'
        elif fobj.container:
            icon = '󱣘'
        elif fobj.document:
            icon = '󰨖'
        elif fobj.image:
            icon = ''
        elif fobj.video:
            icon = ''
        elif 'Dockerfile' in fobj.relative_path:
            icon = ''
        else:
            icon = ''
        return (icon + '  ' if icon else '') + fobj.relative_path

    def infostring(self, fobj, metadata):
        raise NotImplementedError
