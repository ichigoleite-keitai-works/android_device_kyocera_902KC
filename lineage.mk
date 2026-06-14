# Boot animation
TARGET_SCREEN_HEIGHT := 854
TARGET_SCREEN_WIDTH := 480
TARGET_BOOTANIMATION_HALF_RES := true

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/kyocera/902KC/902KC.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := 902KC
PRODUCT_NAME := 902KC
PRODUCT_BRAND := KYOCERA
PRODUCT_MODEL := NP902KC
PRODUCT_MANUFACTURER := kyocera
PRODUCT_RELEASE_NAME := KYOCERA NP902KC

# build fingerprint is placeholder, shouldn't matter that much? - PB
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=902KC \
    PRIVATE_BUILD_DESC="902KC-user 8.1.0 PBDev 0 release-keys"

BUILD_FINGERPRINT := kyocera/902KC/902KC:8.1.0/PBDev/0:user/release-keys