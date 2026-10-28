/*
 * Copyright 2026, code4hack
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdbool.h>
#include <dirent.h>
#include <sched.h>
#include <signal.h>
#include <sys/un.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <linux/sched.h>
#include <linux/sched/types.h>

#include <sched.h>
#include <systemd/sd-journal.h>
#include <libevdev/libevdev.h>
#include <libevdev/libevdev-uinput.h>


bool g_running = false;
const uint32_t G_T_FIND_DEV = 2;
const char g_joystick_name[] = "BEITONG BTP-KP20D BFM DONGLE";


struct libevdev *
find_dev_by_name(const char *name) {
    char path[256] = {0};
    struct libevdev *dev = NULL;
    int index = 0;

    while (true) {
        snprintf(path, sizeof(path), "/dev/input/event%d", index);
        path[sizeof(path)-1] = '\0';

        int fd = open(path, O_RDWR | O_CLOEXEC);
        if (fd < 0)
            break;

        if (libevdev_new_from_fd(fd, &dev) == 0) {
            const char *dev_name = libevdev_get_name(dev);
            if (strncmp(name, dev_name, sizeof(name)) == 0)
                return dev;
            libevdev_free(dev);
        }

        close(fd);
        ++index;
    }
    return NULL;
}


void
process_event(struct libevdev *dev, struct libevdev_uinput *uidev) {
    int rc = 0;

    while (g_running) {
        struct input_event ev = {0};

        rc = libevdev_next_event(dev, LIBEVDEV_READ_FLAG_NORMAL, &ev);

        while (rc == LIBEVDEV_READ_STATUS_SYNC) {
            rc = libevdev_next_event(dev, LIBEVDEV_READ_STATUS_SYNC, &ev);
        }

        if (rc == -EAGAIN) {
            usleep(10000);
            continue;
        } else if (rc == LIBEVDEV_READ_STATUS_SUCCESS) {
            /*
            printf("ev.type: %hi\n", ev.type);
            printf("ev.code: %hi\n", ev.code);
            printf("ev.value: %hi\n", ev.value);
            */
            if (ev.type == EV_ABS) {
                if (ev.code == 1)
                    continue;
            }
        }
        libevdev_uinput_write_event(uidev, ev.type, ev.code, ev.value);
    }
}


void
signal_handler(int signum, siginfo_t *info, void *extra) {
    g_running = false;
}


void
set_scheduler_priority() {
    struct sched_param sp = {0};
    sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
    if (sched_setscheduler(0, SCHED_FIFO, &sp) == -1) {
        sd_journal_print(LOG_ERR, "jremap: set scheduler priority failed");
    }
}


void
set_signal_handler() {
    struct sigaction action = {0};
    action.sa_flags = SA_SIGINFO;
    action.sa_sigaction = signal_handler;

    sigaction(SIGTERM, &action, NULL);
}


int
main(int argc, char **argv) {
    g_running = true;

    set_scheduler_priority();
    set_signal_handler();

    struct libevdev *dev = NULL;
    while (g_running) {
        dev = find_dev_by_name(g_joystick_name);
        if (dev != NULL)
            break;
        sleep(G_T_FIND_DEV);
    }

    if (!g_running)
        exit(0);

    sd_journal_print(LOG_INFO, "jremap: found input device [%s]", g_joystick_name);

    struct libevdev_uinput *uidev = NULL;
    int err = libevdev_uinput_create_from_device(dev, LIBEVDEV_UINPUT_OPEN_MANAGED, &uidev);
    if (err != 0) {
        sd_journal_print(LOG_ERR, "jremap: libevdev_uinput_create_from_device failed");
        libevdev_free(dev);
        exit(1);
    }

    libevdev_grab(dev, LIBEVDEV_GRAB);
    process_event(dev, uidev);
    libevdev_grab(dev, LIBEVDEV_UNGRAB);
    libevdev_free(dev);
    libevdev_uinput_destroy(uidev);

    exit(0);
}


/*
 * vim: ts=4 sw=4 sts=4 ft=c et:
 */
