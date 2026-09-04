# Recovery-only keypad to virtual mouse/keyboard bridge. The stock matrix
# keypad remains the hardware source; TWRP consumes the uinput device emitted
# by 902kc-keyptrd instead of consuming matrix_keypad directly.
TARGET_RECOVERY_DEVICE_MODULES += 902kc-keyptrd