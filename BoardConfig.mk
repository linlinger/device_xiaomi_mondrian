#
# Copyright (C) 2022-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from the proprietary version
include vendor/xiaomi/mondrian/BoardConfigVendor.mk

DEVICE_PATH := device/xiaomi/mondrian
KERNEL_PREBUILT_DIR := $(DEVICE_PATH)/kernel

# Audio
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := true
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_LSM_HIDL := true
AUDIO_FEATURE_ENABLED_PAL_HIDL := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true

TARGET_USES_QCOM_MM_AUDIO := true

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service \
    bootctrl.xiaomi_sm8450 \
    bootctrl.xiaomi_sm8450.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/configs/config.fs

# HIDL
DEVICE_MATRIX_FILE := $(COMMON_PATH)/hidl/compatibility_matrix.xml

DEVICE_MANIFEST_SKUS := \
    cape \
    taro
DEVICE_MANIFEST_CAPE_FILES := \
    $(COMMON_PATH)/hidl/manifest_taro.xml \
    $(COMMON_PATH)/hidl/manifest_xiaomi.xml
DEVICE_MANIFEST_TARO_FILES := $(DEVICE_MANIFEST_CAPE_FILES)

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(COMMON_PATH)/hidl/vendor_framework_compatibility_matrix.xml \
    $(COMMON_PATH)/hidl/xiaomi_framework_compatibility_matrix.xml \
    vendor/aosp/config/device_framework_matrix.xml
	
# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):init_xiaomi_mondrian
TARGET_RECOVERY_DEVICE_MODULES ?= init_xiaomi_mondrian

# Kernel
TARGET_PREBUILT_DTB := $(KERNEL_PREBUILT_DIR)/dtbs/dtb
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PREBUILT_DIR)/dtbs

PRODUCT_COPY_FILES += $(KERNEL_PREBUILT_DIR)/dtbs/dtb:dtb.img

TARGET_NEEDS_DTBOIMAGE := false
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PREBUILT_DIR)/dtbs/dtbo.img

TARGET_FORCE_PREBUILT_KERNEL := true
INLINE_KERNEL_BUILDING := true
TARGET_PREBUILT_KERNEL := $(KERNEL_PREBUILT_DIR)/Image

PRODUCT_COPY_FILES += $(KERNEL_PREBUILT_DIR)/Image:kernel

# Kernel Modules
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(KERNEL_PREBUILT_DIR)/vendor_ramdisk/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PREBUILT_DIR)/vendor_ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PREBUILT_DIR)/vendor_ramdisk/modules.blocklist
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PREBUILT_DIR)/vendor_ramdisk/modules.load.recovery))

BOARD_VENDOR_RAMDISK_FRAGMENTS := dlkm
BOARD_VENDOR_RAMDISK_FRAGMENT.dlkm.KERNEL_MODULE_DIRS := top

BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PREBUILT_DIR)/vendor_dlkm/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PREBUILT_DIR)/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=  $(KERNEL_PREBUILT_DIR)/vendor_dlkm/modules.blocklist

# Power
TARGET_POWERHAL_MODE_EXT := $(COMMON_PATH)/power/power-mode.cpp

# Properties
TARGET_ODM_PROP += $(COMMON_PATH)/properties/odm.prop
TARGET_PRODUCT_PROP += $(COMMON_PATH)/properties/product.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/properties/system.prop
TARGET_SYSTEM_EXT_PROP += $(COMMON_PATH)/properties/system_ext.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/properties/vendor.prop

# Recovery
#namespace definition for librecovery_updater
#differentiate legacy 'sg' or 'bsg' framework
SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

# Screen density
TARGET_SCREEN_DENSITY := 560

# Vibrator
TARGET_QTI_VIBRATOR_EFFECT_LIB := libqtivibratoreffect.xiaomi
TARGET_QTI_VIBRATOR_USE_EFFECT_STREAM := true
