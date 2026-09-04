#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/embedded.mk)

# Inherit from 902KC device
$(call inherit-product, device/kyocera/902KC/device.mk)

# Inherit some common OmniROM stuff.
$(call inherit-product, vendor/omni/config/common.mk)

PRODUCT_DEVICE := 902KC
PRODUCT_NAME := lineage_902KC
PRODUCT_BRAND := KYOCERA
PRODUCT_MODEL := NP902KC
PRODUCT_MANUFACTURER := kyocera

PRODUCT_GMS_CLIENTID_BASE := android-kyocera

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="902KC-user 8.1.0 1.030AN.0094.a 1.030AN.0094.a release-keys" \
    BuildFingerprint=KYOCERA/902KC/902KC:8.1.0/1.030AN.0094.a/1.030AN.0094.a:user/release-keys
