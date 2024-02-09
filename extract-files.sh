#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/init/init.embmssl_server.rc)
            sed -i -n '/interface/!p' "${2}"
            ;;
        vendor/etc/vintf/manifest/c2_manifest_vendor.xml)
            sed -ni '/dolby/!p' "${2}"
            ;;
        vendor/bin/hw/android.hardware.security.keymint-service-qti)
            "${PATCHELF}" --add-needed "android.hardware.security.rkp-V3-ndk.so" "${2}"
            ;;
        vendor/etc/camera/mondrian_enhance_motiontuning.xml|vendor/etc/camera/mondrian_motiontuning.xml)
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        vendor/etc/camera/pureView_parameter.xml)
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=mondrian
export DEVICE_COMMON=sm8450-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
