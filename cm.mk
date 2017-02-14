## Specify phone tech before including full_phone

# Release name
PRODUCT_RELEASE_NAME := maxi_lte

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/tele2/maxi_lte/device_maxi_lte.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := maxi_lte
PRODUCT_NAME := cm_maxi_lte
PRODUCT_BRAND := tele2
PRODUCT_MODEL := Tele2 Maxi LTE
PRODUCT_MANUFACTURER := tele2
