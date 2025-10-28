import os
import time
import signal
from multiprocessing import Process
from subprocess import CalledProcessError

import uvicorn

from .daemon import Daemon
from .app import app
from .firefox import catch_firefox_signal
from .logger import (
    logger,
    init_systemd_logger
)
from .sway import (
    SwayIpcError,
    init_workspaces
)


__all__ = [
    'Server'
]


def server(*args, **kwargs) -> None:
    host, port = args
    config = uvicorn.Config(
        app,
        host=host,
        port=port,
        access_log=False,
        log_level="error"
    )
    server = uvicorn.Server(config)
    server.run()


def monitor(*args, **kwargs) -> None:
    try:
        catch_firefox_signal()
    except Exception:
        logger.exception("catch_firefox_signal:\n")


class Server(Daemon):
    def __init__(self, host, port, pidfile):
        self.host = host
        self.port = port
        self.processes = []
        super().__init__(pidfile)

    def prepare(self) -> None:
        init_systemd_logger()
        try:
            init_workspaces()
        except SwayIpcError as err:
            logger.error(f"{err.func}:\n{err.msg}")
        except CalledProcessError as err:
            logger.error(
                ("init_workspaces[CalledProcessError]:\n"
                 f"{err.stderr.decode('utf-8')}")
            )
        except OSError as err:
            logger.error(
                f"init_workspaces[OSError]:\n{err.strerror}"
            )
        except Exception:
            logger.exception("init_workspaces:\n")

    def run(self) -> None:
        self.prepare()
        self.processes.append(
            Process(target=server, args=(self.host, self.port))
        )
        self.processes.append(Process(target=monitor))
        for process in self.processes:
            process.start()
        for process in self.processes:
            process.join()

    def finish(self) -> None:
        def kill(p: Process, sig: int) -> None:
            if not (pid := p.pid):
                return
            os.kill(pid, sig)
            for _ in range(300):
                time.sleep(0.2)
                if not p.is_alive():
                    return
            else:
                p.kill()
            p.join()

        if not self.processes:
            return
        kill(self.processes[0], signal.SIGINT)
        for process in self.processes[1:]:
            kill(process, signal.SIGTERM)


# vim: ts=4 sw=4 sts=4 ft=python et:
