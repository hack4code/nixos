import os
import re
import json
import time
import shlex
import signal
import inspect
import subprocess
from pathlib import Path
from typing import Literal

import i3ipc
from i3ipc import Con

from .mpc import (
    play_mpd,
    toggle_mpd,
    get_mpd_state,
    set_mpd_volume,
    reload_mpd
)


__all__ = [
    "set_ncmpcpp_display_time",
    "set_ncmpcpp_display_visualizer",
    "set_ncmpcpp_fullscreen",
    "set_ncmpcpp_for_playing",
    "set_ncmpcpp_for_mpv",
    "set_ncmpcpp_toggle_fullscreen",
    "set_container_toggle_fullscreen",
    "move_container_to_workspace",
    "init_workspaces",
    "resume_ncmpcpp",
    "resume_system",
    "idle_system",
    "sleep_system",
    "shutdown_system",
    "launch_floating_kitty",
    "toggle_btop",
    "move_mpv_to_workspace"
]


Monitor = Literal["thinkpad", "samsung"]
MonitorState = Literal["on", "off"]
monitor_full_name = {
    "thinkpad": "Chimei Innolux Corporation 0x1301 Unknown",
    "samsung": "Samsung Electric Company LS24A600U H4ZRB00248"
}
GpuID = 1 if Path("/dev/dri/card1").exists() else 0;


kitty_config_top = (
    "--override font_family='Source Code Pro' "
    "--override modify_font='cell_height +8px'"
)


kitty_config_ncmpcpp = (
    "--override font_family='MiSans VF' "
    "--override symbol_map='U+4E00-U+9FFF MiSans VF' "
    "--override symbol_map='U+3400-U+4DBF Misans TC VF' "
    "--override modify_font='cell_height +8px'"
)


kitty_config_mutt = (
    "--override font_family='Source Code Pro' "
    "--override symbol_map='U+4E00-U+9FFF Source Han Mono SC' "
    "--override symbol_map='U+3400-U+4DBF Source Han Mono TC' "
    "--override modify_font='cell_height +8px'"
)


kitty_config_yazi = (
    "--override font_family='IosevkaTerm Nerd Font' "
    "--override symbol_map='U+4E00-U+9FFF MiSans VF' "
    "--override symbol_map='U+3400-U+4DBF Misans TC VF' "
    "--override modify_font='cell_height +16px'"
)


kitty_config_weechat = (
    "--override font_family='Source Han Mono SC' "
    "--override symbol_map='U+4E00-U+9FFF Source Han Mono SC' "
    "--override symbol_map='U+3400-U+4DBF Source Han Mono TC' "
    "--override modify_font='cell_height +12px'"
)


command_htop = (
    "exec kitty "
    "--class htop "
    "--name htop "
    f"{kitty_config_top} "
    "--override allow_remote_control=socket "
    "--listen-on=unix:@htop "
    "zsh -c 'htop -M --readonly --drop-capabilities=strict'"
)


command_btop = (
    "exec kitty "
    "--class btop "
    "--name btop "
    f"{kitty_config_top} "
    "--override allow_remote_control=socket "
    "--listen-on=unix:@btop "
    "zsh -c btop"
)


command_linode = (
    "exec kitty "
    "--class linode "
    "--name htop "
    f"{kitty_config_top} "
    "--override allow_remote_control=socket "
    "--listen-on=unix:@linode "
    "zsh -c 'kitty +kitten ssh -t linode TERM=xterm htop -M --readonly'"
)


command_ncmpcpp = (
    "exec kitty "
    "--class ncmpcpp "
    "--name audio-player "
    f"{kitty_config_ncmpcpp} "
    "--override allow_remote_control=socket "
    "--listen-on=unix:@ncmpcpp "
    "zsh -c 'ncmpcpp --quiet'"
)

command_yazi = (
    f"exec DRI_PRIME={GpuID} kitty "
    "--class file-manager "
    "--name yazi "
    f"{kitty_config_yazi} "
    "--override allow_remote_control=no "
    "zsh -c 'yazi ~/movie/'"
)


# command_firefox = f"exec DRI_PRIME={GpuID} firefox -P KISS"
command_firefox = f"exec firefox -P KISS"


command_weechat = (
    f"exec DRI_PRIME={GpuID} kitty "
    "--class weechat "
    "--name weechat "
    f"{kitty_config_weechat} "
    "--override allow_remote_control=no "
    "zsh -c weechat"
)


command_mutt = (
    f"exec DRI_PRIME={GpuID} kitty "
    "--class gmail "
    "--name mutt "
    f"{kitty_config_mutt} "
    "--override allow_remote_control=no "
    "zsh -c 'neomutt -f ~/mail/inbox'"
)


command_kitty = (
    f"exec DRI_PRIME={GpuID} kitty "
    "--class kitty "
    "--name terminal "
    "--listen-on=unix:@kitty "
)


command_zathura = f"exec DRI_PRIME={GpuID} zathura"


command_floating_kitty = (
    f"exec DRI_PRIME={GpuID} kitty "
    "--class floatkitty "
    "zsh -i"
)


ncmpcpp_width = "50ppt"
ncmpcpp_height = "60ppt"


I3 = i3ipc.Connection()


class SwayIpcError(Exception):
    def __init__(self, msg):
        self.msg = msg
        self.func = inspect.stack()[1].function
        super().__init__(msg)


def focus_workspace(workspace: int | str | Con) -> None:
    match workspace:
        case int() | str():
            I3.command(f"workspace {workspace}")

        case Con():
            I3.command(f"workspace {workspace.name}")


def find_workspace_focused() -> Con | None:
    if (container := I3.get_tree().find_focused()) is not None:
        return container.workspace()


def find_workspace_by_name(name: str) -> Con | None:
    workspaces = I3.get_tree().workspaces()
    return next(
        (workspace for workspace in workspaces if workspace.name == name),
        None
    )


def find_floating_container_by_app_id(app_id: str,
                                      workspace: str | Con | None
                                      ) -> Con | None:
    def find(workspace: Con) -> Con | None:
        return next(
            (container for container in workspace.floating_nodes
             if container.app_id == app_id),
            None
        )

    match workspace:
        case Con():
            return find(workspace)

        case str():
            if (workspace := find_workspace_by_name(workspace)) is not None:
                return find(workspace)

        case _:
            for ws in I3.get_tree().workspaces():
                if (container := find(ws)) is not None:
                    return container


def find_container_by_app_id(app_id: str,
                             workspace: str | Con | None = None) -> Con | None:
    def find(workspace: Con) -> Con | None:
        return next(
            (container for container in workspace.leaves()
             if container.app_id == app_id),
            None
        )

    match workspace:
        case Con():
            return find(workspace)

        case str():
            if (workspace := find_workspace_by_name(workspace)) is not None:
                return find_container_by_app_id(app_id, workspace)

        case _:
            for ws in I3.get_tree().workspaces():
                if (container := find(ws)) is not None:
                    return container


def find_container_fullscreen(workspace: Con) -> Con | None:
    if windows_fullscreen := workspace.find_fullscreen():
        return windows_fullscreen[0]


def find_container_after_start(name: str,
                               workspace: Con | str | None = None,
                               *,
                               wait: int = 600) -> Con | None:
    for _ in range(wait):
        time.sleep(0.2)
        if (container :=
                find_container_by_app_id(name, workspace)) is not None:
            return container


def set_container_toggle_fullscreen(app_id: str) -> None:
    workspace_0 = find_workspace_by_name("0")
    if (container := find_container_by_app_id(app_id, workspace_0)) is None:
        raise SwayIpcError(f"container {app_id} not exists")
    if (container_fullscreen :=
            find_container_fullscreen(workspace_0)) is None:
        container.command("fullscreen enable")
    elif container_fullscreen.app_id == app_id:
        container.command("fullscreen disable")
    else:
        container_fullscreen.command("fullscreen disable")
        container.command("fullscreen enable")


def move_container_to_workspace(container: Con,
                                workspace: str, *, focus: bool = True) -> None:
    container.command(f"move to workspace {workspace}")
    if focus:
        container.command("focus")


def set_container_disable_fullscreen(app_id: str) -> None:
    if (container := find_container_by_app_id(app_id, "0")) is None:
        raise SwayIpcError(f"container {app_id} not exists")
    container.command("fullscreen disable")


def set_container_fullscreen(app_id: str, force: bool = False) -> None:
    workspace_0 = find_workspace_by_name("0")
    if (container := find_container_by_app_id(app_id, workspace_0)) is None:
        raise SwayIpcError(f"container {app_id} not exists")
    container_fullscreen = find_container_fullscreen(workspace_0)
    if (container_fullscreen is not None
            and container_fullscreen.app_id != app_id):
        if not force:
            return
        container_fullscreen.command("fullscreen disable")
    container.command("fullscreen enable")


def send_key_to_kitty(app_id: str, key: str) -> None:
    subprocess.run(
        ["kitten",
         "@",
         "--to",
         f"unix:@{app_id}",
         "send-key",
         key],
        capture_output=True,
        check=True
    )


def send_text_to_kitty(app_id: str, text: str) -> None:
    subprocess.run(
        ["kitten",
         "@",
         "--to",
         f"unix:@{app_id}",
         "send-text",
         text],
        capture_output=True,
        check=True
    )


def send_esc_to_htop() -> None:
    for _ in range(16):
        time.sleep(1)
        pipes = subprocess.Popen(
            ["kitten",
             "@",
             "--to",
             "unix:@htop",
             "get-text"],
            text=True,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        out, _ = pipes.communicate()
        if out.find("Mem") != -1:
            send_key_to_kitty("htop", "esc")
            return


def send_esc_to_linode() -> None:
    for _ in range(16):
        time.sleep(1)
        pipes = subprocess.Popen(
            ["kitten",
             "@",
             "--to",
             "unix:@linode",
             "get-text"],
            text=True,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        out, _ = pipes.communicate()
        if out.find("CPU") != -1:
            send_key_to_kitty("linode", "esc")
            return


def set_ncmpcpp_display_home() -> None:
    send_key_to_kitty("ncmpcpp", "1")


def set_ncmpcpp_display_time() -> None:
    send_key_to_kitty("ncmpcpp", "9")


def set_ncmpcpp_display_lyrics() -> None:
    send_text_to_kitty("ncmpcpp", "1ol")


def set_ncmpcpp_display_visualizer() -> None:
    send_key_to_kitty("ncmpcpp", "8")


def set_ncmpcpp_lyrics_down() -> None:
    send_key_to_kitty("ncmpcpp", "j")


def set_ncmpcpp_lyrics_up() -> None:
    send_key_to_kitty("ncmpcpp", "k")


def set_ncmpcpp_for_playing() -> None:
    set_ncmpcpp_fullscreen()
    set_ncmpcpp_display_visualizer()


def set_ncmpcpp_for_pause() -> None:
    set_ncmpcpp_disable_fullscreen()
    set_ncmpcpp_display_home()


def set_ncmpcpp_toggle() -> None:
    toggle_mpd()
    match get_mpd_state():
        case "playing":
            set_ncmpcpp_for_playing()

        case "paused" | "stop":
            set_ncmpcpp_for_pause()


def set_ncmpcpp_fullscreen(force: bool = False) -> None:
    set_container_fullscreen("ncmpcpp", force)


def set_ncmpcpp_disable_fullscreen() -> None:
    set_container_disable_fullscreen("ncmpcpp")


def set_ncmpcpp_toggle_fullscreen() -> None:
    set_container_toggle_fullscreen("ncmpcpp")
    if (container_ncmpcpp := find_container_by_app_id("ncmpcpp", "0")) is None:
        raise SwayIpcError("container ncmpcpp not exists")
    if not container_ncmpcpp.fullscreen_mode and get_mpd_state() != "playing":
        set_ncmpcpp_display_home()


def set_ncmpcpp_after_boot() -> None:
    if get_mpd_state() == "playing":
        set_ncmpcpp_for_playing()
        time.sleep(0.8)
        play_mpd()
    set_mpd_volume(48)


def set_ncmpcpp_for_mpv() -> None:
    set_ncmpcpp_fullscreen()
    set_ncmpcpp_display_time()


def setup_workspace_0() -> None:
    I3.command(f"workspace 0;{command_htop}")
    if (container_htop :=
            find_container_after_start("htop", "0")) is None:
        raise SwayIpcError("container htop not exists")
    container_htop.command(f"focus;splith;{command_linode}")
    if (container_linode :=
            find_container_after_start("linode", "0")) is None:
        raise SwayIpcError("container linode not exists")
    container_linode.command(f"focus;splitv;{command_ncmpcpp}")
    if (container_ncmpcpp :=
            find_container_after_start("ncmpcpp", "0")) is None:
        raise SwayIpcError("container ncmpcpp not exists")
    container_ncmpcpp.command(
        (f"resize set width {ncmpcpp_width};"
         f"resize set height {ncmpcpp_height};"
         "focus")
    )


def setup_workspace_1() -> None:
    I3.command(f"workspace 1;{command_firefox}")


def setup_workspace_2() -> None:
    I3.command(f"workspace 2;{command_weechat}")


def setup_workspace_3() -> None:
    I3.command(f"workspace 3;{command_yazi}")


def setup_workspace_4() -> None:
    I3.command(f"workspace 4;{command_mutt}")


def setup_workspace_5() -> None:
    I3.command(f"workspace 5;{command_kitty}")


def setup_workspaces_for_books() -> None:
    workspace = 6

    def open_book(book: Path) -> None:
        nonlocal workspace
        file_name = str(book.absolute())
        if "'" in file_name:
            I3.command(
                f'workspace {workspace};{command_zathura} "{book.absolute()}"'
            )
        else:
            I3.command(
                f"workspace {workspace};{command_zathura} '{book.absolute()}'"
            )

    def open_dir(p: Path):
        nonlocal workspace
        if workspace > 8:
            return
        for book in p.iterdir():
            if book.is_file() and book.suffix in (".pdf", ".epub"):
                open_book(book)
                workspace += 1

    reading = Path.home() / "book" / ".reading"
    if not reading.exists():
        return
    for d in ("study", "fiction", "non-fiction"):
        p = reading / d
        if not p.exists():
            continue
        open_dir(p)


def move_cursor_to_workspace_0() -> None:
    I3.command("seat - cursor set 1080 800")


def restart_container_linode() -> None:
    if (workspace_0 := find_workspace_by_name("0")) is None:
        raise SwayIpcError("workspace 0 not exists")
    if (container_fullscreen :=
            find_container_fullscreen(workspace_0)) is not None:
        container_fullscreen.command("fullscreen disable")
    if (container_ncmpcpp :=
            find_container_by_app_id("ncmpcpp", workspace_0)) is None:
        raise SwayIpcError("container ncmpcpp not exists")
    if (container_linode :=
            find_container_by_app_id("linode", workspace_0)) is not None:
        os.kill(container_linode.pid, signal.SIGTERM)
    while True:
        time.sleep(0.2)
        if find_container_by_app_id("linode", "0") is None:
            break
    container_ncmpcpp.command(f"focus;splitv;{command_linode}")
    if (container_linode :=
            find_container_after_start("linode", "0")) is None:
        raise SwayIpcError("container linode not exists")
    container_ncmpcpp.command(
        f"swap container with con_id {container_linode.id}"
     )
    container_ncmpcpp.command(f"focus;resize set height {ncmpcpp_height}")


def find_linode_tab_id() -> int | None:
    pipes = subprocess.Popen(
        ["kitten",
         "@",
         "--to",
         "unix:@kitty",
         "ls"],
        text=True,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    out, _ = pipes.communicate()
    result = json.loads(out)
    for item in result:
        for tab in item["tabs"]:
            command = " ".join(
                " ".join(window["cmdline"]) for window in tab["windows"]
            )
            if re.search(r'ssh.+linode$', command, 0):
                return tab["id"]


def close_linode_tab(id_tab: int) -> None:
    subprocess.run(
        ["kitten",
         "@",
         "--to",
         "unix:@kitty",
         "close-tab",
         "--match",
         f"id:{id_tab}"],
        capture_output=True,
        check=True
    )


def launch_linode_tab() -> None:
    command = (
        "kitten "
        "@ "
        "--to unix:@kitty "
        "launch "
        "--dont-take-focus "
        "--type tab "
        f"--cwd '{Path.home()}' "
        "--location first "
        "zsh -i -c 'kssh -t linode'"
    )
    subprocess.run(
        shlex.split(command),
        capture_output=True,
        check=True
    )


def resume_ncmpcpp() -> bool:
    if get_mpd_state() == "playing":
        set_ncmpcpp_for_playing()
        return True
    else:
        return False


def set_monitor_power(monitor: Monitor, state: MonitorState) -> None:
    try:
        I3.command(f"output '{monitor_full_name[monitor]}' power {state}")
    except KeyError:
        raise SwayIpcError("monitor {monitor} not exists")


def resume_system() -> None:
    set_monitor_power("thinkpad", "on")
    set_monitor_power("samsung", "on")
    workspace_focus = find_workspace_focused() or "1"
    restart_container_linode()
    resume_ncmpcpp()
    focus_workspace(workspace_focus)
    move_cursor_to_workspace_0()
    send_esc_to_linode()


def idle_system() -> None:
    if not resume_ncmpcpp():
        set_container_fullscreen("htop", force=True)


def sleep_system() -> None:
    set_monitor_power("thinkpad", "off")
    set_monitor_power("samsung", "off")


def shutdown_system() -> None:
    set_monitor_power("samsung", "off")


def move_mpv_to_workspace(focus: bool = True) -> None:
    if (container_mpv := find_container_after_start("mpv", None)) is None:
        raise SwayIpcError("container mpv not exists")
    move_container_to_workspace(container_mpv, "10", focus=focus)


def launch_floating_kitty() -> None:
    if (workspace_focus := find_workspace_focused()) is None:
        raise SwayIpcError("focused workspace not exists")
    if (find_floating_container_by_app_id("floatkitty",
                                          workspace_focus)) is not None:
        return
    I3.command(f"workspace {workspace_focus.name};{command_floating_kitty}")


def toggle_btop() -> None:
    workspace_focus = find_workspace_focused()
    if (container_btop := find_container_by_app_id("btop", "11")) is None:
        I3.command(f"workspace 11;{command_btop}")
    else:
        os.kill(container_btop.pid, signal.SIGTERM)
        focus_workspace(0)
    if workspace_focus is None:
        focus_workspace(1)
    elif workspace_focus.name == "11" or workspace_focus.name == "0":
        if container_btop is None:
            focus_workspace(11)
    else:
        focus_workspace(workspace_focus)


def wait_egpu_power_on():
    if GpuID != 1:
        return
    name = " ".join(monitor_full_name["samsung"].split(" ")[:3])
    while True:
        for output in I3.get_outputs():
            if output.make == name:
                return
        time.sleep(0.2)


def setup_workspaces() -> None:
    wait_egpu_power_on()
    move_cursor_to_workspace_0()
    setup_workspace_1()
    setup_workspace_2()
    setup_workspace_3()
    setup_workspace_4()
    setup_workspace_5()
    setup_workspaces_for_books()
    focus_workspace(1)
    setup_workspace_0()
    focus_workspace(1)
    send_esc_to_htop()
    send_esc_to_linode()
    set_ncmpcpp_after_boot()


def init_workspaces():
    if (find_container_by_app_id("htop") or
            find_container_by_app_id("ncmpcpp") or
            find_container_by_app_id("mutt")):
        return
    setup_workspaces()


# vim: ts=4 sw=4 sts=4 ft=python et:
