PRODUCT_COPY_FILES += \
    device/redroid/mediacodec.policy.x86:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.nativebridge=1

$(call inherit-product, device/redroid-prebuilts/prebuilts_x86.mk)
$(call inherit-product, vendor/gapps/x86_64/x86_64-vendor.mk)
$(call inherit-product-if-exists, vendor/google/proprietary/widevine-prebuilt/widevine.mk)
$(call inherit-product-if-exists, vendor/intel/proprietary/houdini/houdini.mk)
$(call inherit-product-if-exists, vendor/intel/proprietary/houdini/native_bridge_arm_on_x86.mk)