import sys
import os
import atexit
import signal
from abc import ABC, abstractmethod


__all__ = [
    'Daemon'
]


class Daemon(ABC):
    def __init__(self, pidfile):
        self.pid_file = pidfile
        signal.signal(signal.SIGTERM, self.catch)
        signal.signal(signal.SIGUSR1, self.catch)

    def daemonize(self) -> None:
        try:
            if os.fork():
                sys.exit(0)
        except OSError as err:
            sys.stderr.write(f"fork #1 failed:\n{err}\n")
            sys.stderr.flush()
            sys.exit(1)

        os.chdir('/')
        os.setsid()
        os.umask(0)

        try:
            if os.fork():
                sys.exit(0)
        except OSError as err:
            sys.stderr.write(f"fork #2 failed:\n{err}\n")
            sys.stderr.flush()
            sys.exit(1)

        sys.stdout.flush()
        sys.stderr.flush()
        stdin = open(os.devnull, 'r')
        stdout = open(os.devnull, 'a+')
        stderr = open(os.devnull, 'a+')

        os.dup2(stdin.fileno(), sys.stdin.fileno())
        os.dup2(stdout.fileno(), sys.stdout.fileno())
        os.dup2(stderr.fileno(), sys.stderr.fileno())

        with open(self.pid_file, 'w+') as f:
            f.write(f"{os.getpid()}\n")
        atexit.register(self.remove_pid_file)

    def remove_pid_file(self) -> None:
        if os.path.exists(self.pid_file):
            os.remove(self.pid_file)

    def start(self) -> None:
        self.daemonize()
        self.run()

    def stop(self) -> None:
        self.finish()
        self.remove_pid_file()

    def restart(self) -> None:
        self.finish()
        self.run()

    def catch(self, signum, frame) -> None:
        match signum:
            case signal.SIGTERM:
                self.stop()

            case signal.SIGUSR1:
                self.restart()

    @abstractmethod
    def finish(self) -> None:
        pass

    @abstractmethod
    def run(self) -> None:
        pass


# vim: ts=4 sw=4 sts=4 ft=python et :
