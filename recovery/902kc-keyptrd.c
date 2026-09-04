 /*
 * 902KC recovery keypad virtual pointer bridge
 *
 * Converts the stock matrix_keypad input device into a uinput composite
 * pointer/touch/keyboard for TWRP. Direction keys become relative mouse
 * motion, KEY_ENTER holds a synthetic touchscreen contact at the current
 * cursor position for as long as CENTER is held, and all other matrix keys
 * are passed through.
 *
 * A short CENTER press remains an ordinary tap. Holding CENTER while moving
 * the D-pad produces a real TWRP drag/swipe gesture.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define SOURCE_NAME "matrix_keypad"
#define VIRTUAL_NAME "902KC Recovery Pointer"
#define KEYPTR_ONOFF "/sys/class/keyptr/keyptr/onoff"
#define INPUT_DIR "/dev/input"

#define DISPLAY_WIDTH 480
#define DISPLAY_HEIGHT 854
#define MOVE_UNITS 4
#define TWRP_MOUSE_SPEED_NUM 5
#define TWRP_MOUSE_SPEED_DEN 2
#define INITIAL_REPEAT_MS 50
#define REPEAT_MS 20
#define RETRY_MS 250

static volatile sig_atomic_t g_stop;

static void handle_signal(int sig)
{
    (void)sig;
    g_stop = 1;
}

static int64_t now_ms(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
}

static void sleep_ms(int ms)
{
    struct timespec ts;
    ts.tv_sec = ms / 1000;
    ts.tv_nsec = (long)(ms % 1000) * 1000000L;
    while (!g_stop && nanosleep(&ts, &ts) < 0 && errno == EINTR) {
    }
}

static void disable_stock_keyptr(void)
{
    int fd = open(KEYPTR_ONOFF, O_WRONLY | O_CLOEXEC);
    if (fd < 0)
        return;
    (void)write(fd, "0\n", 2);
    close(fd);
}

static bool test_bit(unsigned int bit, const unsigned long *bits)
{
    const unsigned int bits_per_long = sizeof(unsigned long) * 8;
    return (bits[bit / bits_per_long] >> (bit % bits_per_long)) & 1UL;
}

static bool is_pointer_key(unsigned int code)
{
    switch (code) {
    case KEY_LEFT:
    case KEY_RIGHT:
    case KEY_UP:
    case KEY_DOWN:
    case KEY_LEFT_UP:
    case KEY_LEFT_DOWN:
    case KEY_RIGHT_UP:
    case KEY_RIGHT_DOWN:
    case KEY_ENTER:
        return true;
    default:
        return false;
    }
}

static int find_source_device(void)
{
    DIR *dir = opendir(INPUT_DIR);
    struct dirent *de;

    if (!dir)
        return -1;

    while ((de = readdir(dir)) != NULL) {
        char path[256];
        char name[128] = {0};
        int fd;

        if (strncmp(de->d_name, "event", 5) != 0)
            continue;

        snprintf(path, sizeof(path), INPUT_DIR "/%s", de->d_name);
        fd = open(path, O_RDONLY | O_CLOEXEC);
        if (fd < 0)
            continue;

        if (ioctl(fd, EVIOCGNAME(sizeof(name)), name) >= 0 && strcmp(name, SOURCE_NAME) == 0) {
            closedir(dir);
            fprintf(stderr, "902kc-keyptrd: source %s (%s)\n", path, name);
            return fd;
        }
        close(fd);
    }

    closedir(dir);
    return -1;
}

static int open_uinput(void)
{
    static const char *paths[] = { "/dev/uinput", "/dev/input/uinput" };
    size_t i;

    for (i = 0; i < sizeof(paths) / sizeof(paths[0]); ++i) {
        int fd = open(paths[i], O_WRONLY | O_NONBLOCK | O_CLOEXEC);
        if (fd >= 0)
            return fd;
    }
    return -1;
}

static int emit_event(int fd, uint16_t type, uint16_t code, int32_t value)
{
    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    ev.type = type;
    ev.code = code;
    ev.value = value;
    return write(fd, &ev, sizeof(ev)) == (ssize_t)sizeof(ev) ? 0 : -1;
}

static int emit_sync(int fd)
{
    return emit_event(fd, EV_SYN, SYN_REPORT, 0);
}

static int create_virtual_device(int source_fd)
{
    unsigned long key_bits[(KEY_MAX + sizeof(unsigned long) * 8) / (sizeof(unsigned long) * 8)];
    struct uinput_user_dev uidev;
    int fd;
    unsigned int code;

    memset(key_bits, 0, sizeof(key_bits));
    if (ioctl(source_fd, EVIOCGBIT(EV_KEY, sizeof(key_bits)), key_bits) < 0) {
        perror("902kc-keyptrd: EVIOCGBIT(EV_KEY)");
        return -1;
    }

    fd = open_uinput();
    if (fd < 0) {
        perror("902kc-keyptrd: open uinput");
        return -1;
    }

    /*
     * Keep BTN_LEFT/BTN_RIGHT capabilities so TWRP recognizes this device as
     * a mouse and renders MouseCursor. CENTER itself is intentionally not
     * emitted as BTN_LEFT: TWRP's native touchscreen path is more reliable
     * for activation, so CENTER is translated into ABS touch frames below.
     */
    if (ioctl(fd, UI_SET_EVBIT, EV_KEY) < 0 ||
        ioctl(fd, UI_SET_EVBIT, EV_REL) < 0 ||
        ioctl(fd, UI_SET_EVBIT, EV_ABS) < 0 ||
        ioctl(fd, UI_SET_RELBIT, REL_X) < 0 ||
        ioctl(fd, UI_SET_RELBIT, REL_Y) < 0 ||
        ioctl(fd, UI_SET_ABSBIT, ABS_X) < 0 ||
        ioctl(fd, UI_SET_ABSBIT, ABS_Y) < 0 ||
        ioctl(fd, UI_SET_ABSBIT, ABS_MT_TOUCH_MAJOR) < 0 ||
        ioctl(fd, UI_SET_KEYBIT, BTN_LEFT) < 0 ||
        ioctl(fd, UI_SET_KEYBIT, BTN_RIGHT) < 0) {
        perror("902kc-keyptrd: configuring uinput");
        close(fd);
        return -1;
    }

    for (code = 1; code <= KEY_MAX; ++code) {
        if (!test_bit(code, key_bits) || is_pointer_key(code))
            continue;
        if (ioctl(fd, UI_SET_KEYBIT, code) < 0) {
            perror("902kc-keyptrd: UI_SET_KEYBIT");
            close(fd);
            return -1;
        }
    }

    memset(&uidev, 0, sizeof(uidev));
    snprintf(uidev.name, UINPUT_MAX_NAME_SIZE, "%s", VIRTUAL_NAME);
    uidev.id.bustype = BUS_HOST;
    uidev.id.vendor = 0x0482;
    uidev.id.product = 0x42c0;
    uidev.id.version = 1;
    uidev.absmin[ABS_X] = 0;
    uidev.absmax[ABS_X] = DISPLAY_WIDTH - 1;
    uidev.absmin[ABS_Y] = 0;
    uidev.absmax[ABS_Y] = DISPLAY_HEIGHT - 1;
    uidev.absmin[ABS_MT_TOUCH_MAJOR] = 0;
    uidev.absmax[ABS_MT_TOUCH_MAJOR] = 1;

    if (write(fd, &uidev, sizeof(uidev)) != (ssize_t)sizeof(uidev)) {
        perror("902kc-keyptrd: write uinput_user_dev");
        close(fd);
        return -1;
    }
    if (ioctl(fd, UI_DEV_CREATE) < 0) {
        perror("902kc-keyptrd: UI_DEV_CREATE");
        close(fd);
        return -1;
    }

    fprintf(stderr, "902kc-keyptrd: created '%s'\n", VIRTUAL_NAME);
    return fd;
}

static void set_direction(bool held[KEY_MAX + 1], unsigned int code, bool down)
{
    if (code <= KEY_MAX)
        held[code] = down;
}

static void motion_vector(const bool held[KEY_MAX + 1], int *dx, int *dy)
{
    int x = 0;
    int y = 0;

    if (held[KEY_LEFT])      --x;
    if (held[KEY_RIGHT])     ++x;
    if (held[KEY_UP])        --y;
    if (held[KEY_DOWN])      ++y;
    if (held[KEY_LEFT_UP])   { --x; --y; }
    if (held[KEY_LEFT_DOWN]) { --x; ++y; }
    if (held[KEY_RIGHT_UP])  { ++x; --y; }
    if (held[KEY_RIGHT_DOWN]){ ++x; ++y; }

    if (x < 0) x = -1;
    if (x > 0) x = 1;
    if (y < 0) y = -1;
    if (y > 0) y = 1;

    *dx = x * MOVE_UNITS;
    *dy = y * MOVE_UNITS;
}

static bool any_direction_held(const bool held[KEY_MAX + 1])
{
    int dx, dy;
    motion_vector(held, &dx, &dy);
    return dx != 0 || dy != 0;
}

static int clamp_int(int value, int low, int high)
{
    if (value < low)
        return low;
    if (value > high)
        return high;
    return value;
}

static int emit_motion(int ufd, const bool held[KEY_MAX + 1], int *cursor_x, int *cursor_y)
{
    int dx, dy;
    motion_vector(held, &dx, &dy);
    if (dx == 0 && dy == 0)
        return 0;
    if ((dx && emit_event(ufd, EV_REL, REL_X, dx) < 0) ||
        (dy && emit_event(ufd, EV_REL, REL_Y, dy) < 0) ||
        emit_sync(ufd) < 0)
        return -1;

    /* Mirror TWRP MouseCursor's default 2.5x relative-motion multiplier. */
    *cursor_x = clamp_int(*cursor_x + dx * TWRP_MOUSE_SPEED_NUM / TWRP_MOUSE_SPEED_DEN,
                          0, DISPLAY_WIDTH - 1);
    *cursor_y = clamp_int(*cursor_y + dy * TWRP_MOUSE_SPEED_NUM / TWRP_MOUSE_SPEED_DEN,
                          0, DISPLAY_HEIGHT - 1);
    return 0;
}

static int emit_touch_down(int ufd, int x, int y)
{
    /*
     * Begin a synthetic touchscreen contact at the current mouse cursor.
     *
     * Keep ABS_MT_TOUCH_MAJOR asserted until physical CENTER is released.
     * While the contact remains active, the existing REL_X/REL_Y stream lets
     * TWRP turn D-pad pointer motion into TOUCH_DRAG events.
     */
    if (emit_event(ufd, EV_ABS, ABS_X, x) < 0 ||
        emit_event(ufd, EV_ABS, ABS_Y, y) < 0 ||
        emit_event(ufd, EV_ABS, ABS_MT_TOUCH_MAJOR, 1) < 0 ||
        emit_sync(ufd) < 0)
        return -1;

    return 0;
}

static int emit_touch_up(int ufd, int x, int y)
{
    /*
     * D-pad movement is emitted as EV_REL, while TWRP's touchscreen release
     * path remembers its most recent absolute touch position. Re-submit the
     * current cursor coordinates before lifting the synthetic finger so the
     * TOUCH_RELEASE occurs at the end of the drag rather than at its origin.
     */
    if (emit_event(ufd, EV_ABS, ABS_X, x) < 0 ||
        emit_event(ufd, EV_ABS, ABS_Y, y) < 0 ||
        emit_sync(ufd) < 0 ||
        emit_event(ufd, EV_ABS, ABS_MT_TOUCH_MAJOR, 0) < 0 ||
        emit_sync(ufd) < 0)
        return -1;

    return 0;
}

static bool is_direction(unsigned int code)
{
    switch (code) {
    case KEY_LEFT:
    case KEY_RIGHT:
    case KEY_UP:
    case KEY_DOWN:
    case KEY_LEFT_UP:
    case KEY_LEFT_DOWN:
    case KEY_RIGHT_UP:
    case KEY_RIGHT_DOWN:
        return true;
    default:
        return false;
    }
}

static int run_bridge(int source_fd, int ufd)
{
    bool held[KEY_MAX + 1];
    bool enter_held = false;
    int cursor_x = DISPLAY_WIDTH / 2;
    int cursor_y = DISPLAY_HEIGHT / 2;
    int64_t next_repeat = -1;

    memset(held, 0, sizeof(held));

    while (!g_stop) {
        struct pollfd pfd;
        int timeout = -1;
        int pr;

        pfd.fd = source_fd;
        pfd.events = POLLIN;
        pfd.revents = 0;

        if (any_direction_held(held) && next_repeat >= 0) {
            int64_t remain = next_repeat - now_ms();
            timeout = remain <= 0 ? 0 : (remain > 1000 ? 1000 : (int)remain);
        }

        pr = poll(&pfd, 1, timeout);
        if (pr < 0) {
            if (errno == EINTR)
                continue;
            perror("902kc-keyptrd: poll");
            return -1;
        }

        if (pr == 0) {
            if (emit_motion(ufd, held, &cursor_x, &cursor_y) < 0)
                return -1;
            next_repeat = now_ms() + REPEAT_MS;
            continue;
        }

        if (pfd.revents & (POLLERR | POLLHUP | POLLNVAL))
            return -1;

        if (pfd.revents & POLLIN) {
            struct input_event ev;
            ssize_t n = read(source_fd, &ev, sizeof(ev));
            if (n != (ssize_t)sizeof(ev)) {
                if (n < 0 && errno == EINTR)
                    continue;
                return -1;
            }

            if (ev.type != EV_KEY)
                continue;

            if (is_direction(ev.code)) {
                bool down = ev.value != 0;
                bool was_down = ev.code <= KEY_MAX ? held[ev.code] : false;
                set_direction(held, ev.code, down);

                if (down && !was_down) {
                    if (emit_motion(ufd, held, &cursor_x, &cursor_y) < 0)
                        return -1;
                    next_repeat = now_ms() + INITIAL_REPEAT_MS;
                } else if (!any_direction_held(held)) {
                    next_repeat = -1;
                }
                continue;
            }

            if (ev.code == KEY_ENTER) {
                bool down = ev.value != 0;

                /*
                 * Physical CENTER owns the lifetime of the synthetic touch.
                 *
                 * CENTER down:
                 *     TOUCH_START at the current cursor.
                 *
                 * CENTER held + D-pad:
                 *     existing REL_X/REL_Y motion becomes TOUCH_DRAG in TWRP.
                 *
                 * CENTER up:
                 *     TOUCH_RELEASE at the final cursor position.
                 */
                if (down && !enter_held) {
                    if (emit_touch_down(ufd, cursor_x, cursor_y) < 0)
                        return -1;
                } else if (!down && enter_held) {
                    if (emit_touch_up(ufd, cursor_x, cursor_y) < 0)
                        return -1;
                }

                enter_held = down;
                continue;
            }

            if (emit_event(ufd, EV_KEY, ev.code, ev.value) < 0 || emit_sync(ufd) < 0)
                return -1;
        }
    }

    return 0;
}

int main(void)
{
    signal(SIGTERM, handle_signal);
    signal(SIGINT, handle_signal);

    disable_stock_keyptr();

    while (!g_stop) {
        int source_fd = find_source_device();
        int ufd;

        if (source_fd < 0) {
            sleep_ms(RETRY_MS);
            continue;
        }

        /*
         * TWRP still opens matrix_keypad even when TW_INPUT_BLACKLIST is set
         * in this build. Take exclusive ownership of the physical keypad so
         * the bridge is the sole source of UI events derived from it.
         */
        if (ioctl(source_fd, EVIOCGRAB, 1) < 0) {
            perror("902kc-keyptrd: EVIOCGRAB matrix_keypad");
            close(source_fd);
            sleep_ms(RETRY_MS);
            continue;
        }
        fprintf(stderr, "902kc-keyptrd: grabbed %s exclusively\n", SOURCE_NAME);

        ufd = create_virtual_device(source_fd);
        if (ufd < 0) {
            (void)ioctl(source_fd, EVIOCGRAB, 0);
            close(source_fd);
            sleep_ms(RETRY_MS);
            continue;
        }

        (void)run_bridge(source_fd, ufd);

        ioctl(ufd, UI_DEV_DESTROY);
        close(ufd);
        (void)ioctl(source_fd, EVIOCGRAB, 0);
        close(source_fd);

        if (!g_stop)
            sleep_ms(RETRY_MS);
    }

    disable_stock_keyptr();
    return 0;
}