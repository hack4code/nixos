/*
 * Copyright 2025, code4hack
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <dirent.h>
#include <signal.h>
#include <sched.h>
#include <sys/un.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <linux/sched.h>
#include <linux/sched/types.h>

#include <pthread.h>
#include <systemd/sd-journal.h>
#include <json-c/json.h>
#include <libevdev/libevdev.h>
#include <libevdev/libevdev-uinput.h>


const uint32_t G_T_FIND_DEV = 2;
const uint32_t G_T_CONNECT_SWAY = 30;

bool g_running = true;
char g_focus_app_id[256] = {0};
struct libevdev *g_kbd_dev = NULL;
struct libevdev_uinput *g_kbd_uidev = NULL;
pthread_mutex_t g_mutex_app_id;
pthread_t g_thread_remap, g_thread_event;

static const char g_kbd_name[] =
"CHERRY MX-LP 2.1 Compact Wireless Mechanical Keyboard";
static const char MAGIC[] = {'i', '3', '-', 'i', 'p', 'c'};
#define IPC_HEADER_SIZE (sizeof(MAGIC) + 8)


enum ipc_command_type {
    IPC_COMMAND = 0,
    IPC_GET_WORKSPACES = 1,
    IPC_SUBSCRIBE = 2,
};

struct response {
    uint32_t size;
    uint32_t type;
    char *payload;
};


void
free_kbd_dev() {
    if (g_kbd_dev != NULL) {
        libevdev_grab(g_kbd_dev, LIBEVDEV_UNGRAB);
        libevdev_free(g_kbd_dev);
        g_kbd_dev = NULL;
    }
    if (g_kbd_uidev != NULL) {
        libevdev_uinput_destroy(g_kbd_uidev);
        g_kbd_uidev = NULL;
    }
}


void
grab_kbd_dev(struct libevdev *dev, struct libevdev_uinput *uidev) {
    libevdev_grab(dev, LIBEVDEV_GRAB);
    g_kbd_dev = dev;
    g_kbd_uidev = uidev;
}


bool
set_thread_priority(pthread_t tid, int policy, int priority) {
    int err;
    struct sched_param param = {0};
    param.sched_priority = priority;
    err = pthread_setschedparam(tid, policy, &param);
    if (err != 0) {
        sd_journal_print(
                LOG_ERR,
                "set_thread_priority: pthread_setschedparam error value %d\n",
                err);
        return false;
    }
    return true;
}


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
process_key_event(struct libevdev *dev, struct libevdev_uinput *uidev) {
    bool is_ctrl_pressed = false;
    bool is_shift_pressed = false;
    bool is_alt_pressed = false;

    while (true) {
        struct input_event ev = {0};

        int err;
        bool is_remap;
        err = libevdev_next_event(
                dev,
                LIBEVDEV_READ_FLAG_NORMAL | LIBEVDEV_READ_FLAG_BLOCKING,
                &ev);
        is_remap = false;
        if (err == 0 && ev.type == EV_KEY) {
            switch (ev.code) {
                case KEY_CAPSLOCK:
                    if (ev.value == 1)
                        is_ctrl_pressed = true;
                    else if (ev.value == 0)
                        is_ctrl_pressed = false;
                    libevdev_uinput_write_event(
                            uidev,
                            EV_KEY,
                            KEY_LEFTCTRL,
                            ev.value);
                    is_remap = true;
                    break;

                case KEY_LEFTSHIFT:
                case KEY_RIGHTSHIFT:
                    if (ev.value == 1)
                        is_shift_pressed = true;
                    else if (ev.value == 0)
                        is_shift_pressed = false;
                    break;

                case KEY_RIGHTCTRL:
                    libevdev_uinput_write_event(
                            uidev,
                            EV_KEY,
                            KEY_RIGHTMETA,
                            ev.value);
                    is_remap = true;
                    break;

                case KEY_LEFTALT:
                case KEY_RIGHTALT:
                    if (ev.value == 1)
                        is_alt_pressed = true;
                    else if (ev.value == 0)
                        is_alt_pressed = false;
                    break;
            }

            if (is_ctrl_pressed && !is_alt_pressed && !is_shift_pressed) {
                switch (ev.code) {
                    case KEY_LEFTBRACE:
                        libevdev_uinput_write_event(
                                uidev,
                                EV_KEY,
                                KEY_ESC,
                                ev.value);
                        is_remap = true;
                        break;
                }
            }

            pthread_mutex_lock(&g_mutex_app_id);
            if (strncmp(g_focus_app_id, "firefox", 7) == 0) {
                pthread_mutex_unlock(&g_mutex_app_id);
                if (is_alt_pressed && !is_shift_pressed && !is_ctrl_pressed) {
                    switch (ev.code) {
                        case KEY_T:
                        case KEY_F:
                        case KEY_B:
                            is_remap = true;
                            break;
                    }
                } else if (is_ctrl_pressed &&
                           !is_shift_pressed && !is_alt_pressed) {
                    switch (ev.code) {
                        case KEY_J:
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_PAGEUP,
                                    ev.value);
                            is_remap = true;
                            break;

                        case KEY_K:
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_PAGEDOWN,
                                    ev.value);
                            is_remap = true;
                            break;

                        case KEY_H:
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_LEFTSHIFT,
                                    ev.value);
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_PAGEUP,
                                    ev.value);
                            is_remap = true;
                            break;

                        case KEY_L:
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_LEFTSHIFT,
                                    ev.value);
                            libevdev_uinput_write_event(
                                    uidev,
                                    EV_KEY,
                                    KEY_PAGEDOWN,
                                    ev.value);
                            is_remap = true;
                            break;
                    }
                }
            } else {
                pthread_mutex_unlock(&g_mutex_app_id);
            }
        }

        if (!is_remap)
            libevdev_uinput_write_event(
                    uidev,
                    ev.type,
                    ev.code,
                    ev.value);
    }
}


void *
thread_key_remap(void *name) {
    struct libevdev *dev = NULL;
    while (true) {
        dev = find_dev_by_name((const char *)name);
        if (dev != NULL)
            break;
        sleep(G_T_FIND_DEV);
    }

    struct libevdev_uinput *uidev = NULL;
    int err = libevdev_uinput_create_from_device(
            dev,
            LIBEVDEV_UINPUT_OPEN_MANAGED,
            &uidev);
    if (err != 0) {
        sd_journal_print(
                LOG_ERR,
                "thread_key_remap: libevdev_uinput_create_from_device error\n");
        libevdev_free(dev);
        pthread_exit(NULL);
    }

    grab_kbd_dev(dev, uidev);
    process_key_event(dev, uidev);
    free_kbd_dev();

    return NULL;
}


bool
ipc_set_timeout(int fd, struct timeval tv) {
    if (setsockopt(
                fd,
                SOL_SOCKET,
                SO_RCVTIMEO,
                &tv,
                sizeof(tv)) == -1) {
        sd_journal_print(LOG_ERR, "ipc_set_timeout: setsockopt error\n");
        return false;
    }
    return true;
}


char *
get_sock_env() {
    const char *sock = getenv("SWAYSOCK");
    if (sock != NULL) {
        return strdup(sock);
    }
    return NULL;
}


struct dirent *
find_sway_socket(DIR *d) {
    struct dirent *e = NULL;
    while ((e = readdir(d)) != NULL) {
        if (e->d_type != DT_SOCK)
            continue;
        if (strncmp(e->d_name, "sway-ipc", 8) == 0)
            return e;
    }
    return NULL;
}


char *
get_sock_path() {
    DIR *path = opendir("/run/user/");
    if (path == NULL) {
        sd_journal_print(LOG_ERR, "can't read /run/user/ directory\n");
        return NULL;
    }

    char name[256] = {0};
    struct dirent *e = NULL;
    struct dirent *sock = NULL;
    while ((e = readdir(path)) != NULL) {
        if (e->d_type != DT_DIR)
            continue;
        if (snprintf(name, sizeof(name), "/run/user/%s", e->d_name) < 0) {
            sd_journal_print(LOG_ERR, "directory name is too long");
            exit(1);
        }
        name[sizeof(name)-1] = '\0';
        DIR *d = opendir(name);
        if (d != NULL) {
            sock = find_sway_socket(d);
            if (sock != NULL) {
                closedir(d);
                break;
            }
            closedir(d);
        }
    }
    closedir(path);

    if (sock == NULL)
        return NULL;

    if (snprintf(name,
                sizeof(name),
                "/run/user/%s/%s",
                e->d_name,
                sock->d_name) < 0) {
        sd_journal_print(LOG_ERR, "socket name is too long");
        exit(1);
    }
    name[sizeof(name)-1] = '\0';
    return strdup(name);
}


int
ipc_open() {
    char *path = NULL;
    path = get_sock_env();
    if (path == NULL)
        path = get_sock_path();
    if (path == NULL)
        return -1;

    int fd;
    struct sockaddr_un sk_un = {0};
    fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd == -1) {
        sd_journal_print(LOG_ERR, "ipc_open: socket error\n");
        free(path);
        return -1;
    }

    sk_un.sun_family = AF_UNIX;
    strncpy(sk_un.sun_path, path, strlen(path));
    free(path);

    int err;
    err = connect(
            fd,
            (struct sockaddr *) &sk_un,
            sizeof(struct sockaddr_un));
    if (err == -1) {
        sd_journal_print(LOG_ERR, "ipc_open: connect error\n");
        close(fd);
        return -1;
    }

    return fd;
}


bool
ipc_send(int fd, uint32_t type, const char *payload, uint32_t *len) {
    char msg[IPC_HEADER_SIZE];

    memcpy(msg, MAGIC, sizeof(MAGIC));
    memcpy(msg + sizeof(MAGIC), len, sizeof(*len));
    memcpy(msg + sizeof(MAGIC) + sizeof(*len), &type, sizeof(type));

    if (write(fd, msg, IPC_HEADER_SIZE) == -1) {
        sd_journal_print(LOG_ERR, "ipc_send: write error\n");
        return false;
    }

    if (write(fd, payload, *len) == -1) {
        sd_journal_print(LOG_ERR, "ipc_send: write error\n");
        return false;
    }

    return true;
}


struct response *
ipc_recv(int fd) {
    char data[IPC_HEADER_SIZE] = {0};

    size_t total = 0;
    while (total < IPC_HEADER_SIZE) {
        ssize_t size = recv(
                fd,
                data + total,
                IPC_HEADER_SIZE - total,
                0);
        if (size <= 0) {
            sd_journal_print(
                    LOG_INFO,
                    "ipc_recv: recv error(%d)\n",
                    (int)size);
            return NULL;
        }
        total += size;
    }

    struct response *response = malloc(sizeof(struct response));
    if (response == NULL)
        return NULL;

    memcpy(&response->size,
            data + sizeof(MAGIC),
            sizeof(uint32_t));
    memcpy(&response->type,
            data + sizeof(MAGIC) + sizeof(uint32_t),
            sizeof(uint32_t));

    char *payload = malloc(response->size + 1);
    if (!payload) {
        sd_journal_print(LOG_ERR, "ipc_recv: malloc error\n");
        free(response);
        return NULL;
    }

    total = 0;
    while (total < response->size) {
        ssize_t size = recv(
                fd,
                payload + total,
                response->size - total,
                0);
        if (size < 0) {
            sd_journal_print(LOG_ERR, "ipc_recv: recv error\n");
            free(response);
            return NULL;
        }
        total += size;
    }

    payload[response->size] = '\0';
    response->payload = payload;
    return response;
}


void
free_response(struct response *response) {
    free(response->payload);
    free(response);
}


bool
subscribe_window_event(int fd) {
    struct timeval timeout = {.tv_sec = 0, .tv_usec = 0};
    if (ipc_set_timeout(fd, timeout) == false)
        return false;

    uint32_t type = IPC_SUBSCRIBE;
    const char payload[] = "[\"window\"]";
    uint32_t len = strlen(payload);
    if (ipc_send(fd, type, payload, &len) == false)
        return false;

    struct response *reply = ipc_recv(fd);
    if (reply == NULL)
        return false;

    json_object *root = json_tokener_parse(reply->payload);
    if (root == NULL) {
        sd_journal_print(
                LOG_ERR,
                "subscribe_window_event: json_tokener_parse error\n");
        free_response(reply);
        return false;
    }
    json_object *success = json_object_object_get(root, "success");
    if (success == NULL) {
        sd_journal_print(
                LOG_ERR,
                "subscribe_window_event: json_object_object_get error\n");
        json_object_put(root);
        free_response(reply);
        return false;
    }

    bool result = json_object_get_boolean(success);
    json_object_put(root);
    free_response(reply);
    return result;
}


void
process_window_event(int fd) {
    while (true) {
        struct response *reply = ipc_recv(fd);
        if (reply == NULL) {
            sd_journal_print(
                    LOG_ERR,
                    "process_window_event: ip_recv return NULL\n");
            return;
        }

        json_object *root = json_tokener_parse(reply->payload);
        if (root == NULL) {
            sd_journal_print(
                    LOG_ERR,
                    "process_window_event: json_tokener_parse error\n");
            free_response(reply);
            return;
        }

        json_object *o_change = json_object_object_get(root, "change");
        if (o_change == NULL)
            goto free_reply;

        const char *s_change = json_object_get_string(o_change);
        if (s_change == NULL)
            goto free_reply;

        if (strncmp(s_change, "focus", 5) != 0)
            goto free_reply;

        json_object *o_container = json_object_object_get(root, "container");
        if (o_container == NULL)
            goto free_reply;

        json_object *o_focus = json_object_object_get(o_container, "focused");
        if (o_focus == NULL)
            goto free_reply;

        if (json_object_get_boolean(o_focus) == false)
            goto free_reply;

        json_object *o_app_id = json_object_object_get(o_container, "app_id");
        if (o_app_id == NULL)
            goto free_reply;

        const char *s_app_id = json_object_get_string(o_app_id);
        if (s_app_id == NULL)
            goto free_reply;

        pthread_mutex_lock(&g_mutex_app_id);
        strncpy(g_focus_app_id, s_app_id, sizeof(g_focus_app_id));
        g_focus_app_id[sizeof(g_focus_app_id)-1] = '\0';
        pthread_mutex_unlock(&g_mutex_app_id);

free_reply:
        json_object_put(root);
        free_response(reply);
    }
}


void *
thread_window_event(void *) {
    int fd;

    while (true) {
        while (true) {
            fd = ipc_open();
            if (fd != -1)
                break;
            sleep(G_T_CONNECT_SWAY);
        }

        if (subscribe_window_event(fd) == false) {
            sd_journal_print(LOG_ERR, "subscribe_window_event error\n");
            close(fd);
            continue;
        }

        sd_journal_print(LOG_INFO, "process_window_event begin\n");
        process_window_event(fd);
        sd_journal_print(LOG_INFO, "process_window_event end\n");
        pthread_mutex_lock(&g_mutex_app_id);
        memset(g_focus_app_id, 0, sizeof(g_focus_app_id));
        pthread_mutex_unlock(&g_mutex_app_id);
        close(fd);
    }
}


void
run_thread_remap() {
    int err;
    err = pthread_create(
            &g_thread_remap,
            NULL,
            thread_key_remap,
            (void *)g_kbd_name);
    if (err != 0) {
        sd_journal_print(
                LOG_WARNING,
                "pthread_create error: thread_key_remap\n");
        exit(1);
    }

    if (set_thread_priority(g_thread_remap, SCHED_FIFO, 99) == false)
        sd_journal_print(
                LOG_WARNING,
                "can't set priority for thread_key_remap\n");
}


void
run_thread_event() {
    int err;
    err = pthread_create(
            &g_thread_event,
            NULL,
            thread_window_event,
            NULL);
    if (err != 0) {
        sd_journal_print(
                LOG_ERR,
                "pthread_create error: thread_window_event\n");
        exit(1);
    }
}


void
signal_handler(int signum, siginfo_t *info, void *extra) {
    g_running = false;
    pthread_cancel(g_thread_remap);
    pthread_cancel(g_thread_event);
}


int
main(int argc, char **argv) {
    struct sigaction action = {0};
    action.sa_flags = SA_SIGINFO;
    action.sa_sigaction = signal_handler;
    sigaction(SIGTERM, &action, NULL);

    g_running = true;
    pthread_mutex_init(&g_mutex_app_id, 0);

    while (g_running) {
        sd_journal_print(LOG_INFO, "kremap running\n");
        run_thread_remap();
        run_thread_event();
        pthread_join(g_thread_event, NULL);
        pthread_join(g_thread_remap, NULL);
    }

    pthread_mutex_destroy(&g_mutex_app_id);
    sd_journal_print(LOG_INFO, "kremap exited\n");
    exit(0);
}


/*
 * vim: ts=4 sw=4 sts=4 ft=c et:
 */
