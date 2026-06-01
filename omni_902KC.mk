# Inherit product configuration from dependencies
$(call inherit-product, $(SRC_TARGET_DIR)/product/embedded.mk)
$(call inherit-product, device/kyocera/902KC/device.mk)
$(call inherit-product, vendor/omni/config/common.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := 902KC
PRODUCT_NAME := omni_902KC
PRODUCT_BRAND := KYOCERA
PRODUCT_MODEL := NP902KC
PRODUCT_MANUFACTURER := kyocera
PRODUCT_RELEASE_NAME := KYOCERA NP902KC