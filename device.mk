#
# Copyright (C) 2022-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from xiaomi sm8450-common
$(call inherit-product, device/xiaomi/sm8450-common/common.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/xiaomi/mondrian/mondrian-vendor.mk)

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/mixer_paths_overlay_static.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_cape/mixer_paths_overlay_static.xml \
    $(LOCAL_PATH)/audio/resourcemanager_waipio_mtp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_cape/resourcemanager_waipio_mtp.xml

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/displayconfigs/display_id_4630946545580055170.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630946545580055170.xml \
    $(LOCAL_PATH)/configs/displayconfigs/resolution_switch_process_list_backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/resolution_switch_process_list_backup.xml \
    $(LOCAL_PATH)/configs/displayconfigs/thermal_brightness_control.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/thermal_brightness_control.xml

# Overlay
PRODUCT_PACKAGES += \
    ApertureResMondrian \
    FrameworksResMondrian \
    SettingsProviderResMondrian \
    SettingsResMondrian \
    SystemUIResMondrian \
    WifiResMondrian

# Sensors
PRODUCT_PACKAGES += \
    sensors.xiaomi

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
