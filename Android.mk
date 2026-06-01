LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE), 902KC)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif