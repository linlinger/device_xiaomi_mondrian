#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=marble
VENDOR=mondrian

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
    -n | --no-cleanup)
        CLEAN_VENDOR=false
        ;;
    -k | --kang)
        KANG="--kang"
        ;;
    -s | --section)
        SECTION="${2}"
        shift
        CLEAN_VENDOR=false
        ;;
    *)
        SRC="${1}"
        ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/etc/init/init.embmssl_server.rc)
            sed -i -n '/interface/!p' "${2}"
            ;;
        vendor/etc/vintf/manifest/c2_manifest_vendor.xml)
            sed -ni '/dolby/!p' "${2}"
            ;;
        vendor/lib64/libsdmcore.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v33.so" "${2}"
            ;;
        vendor/lib/libsdmcore.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v33.so" "${2}"
            ;;
        vendor/lib64/hw/displayfeature.default.so)
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        vendor/lib/hw/displayfeature.default.so)
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        vendor/bin/hw/android.hardware.security.keymint-service-qti)
            "${PATCHELF}" --add-needed "android.hardware.security.rkp-V3-ndk.so" "${2}"
            ;;
        system/lib64/libcamera_algoup_jni.xiaomi.so|system/lib64/libcamera_mianode_jni.xiaomi.so)
            "${PATCHELF}" --add-needed "libgui_shim_miuicamera.so" "${2}"
            ;;
        system/lib64/libmicampostproc_client.so)
            "${PATCHELF}" --remove-needed "libhidltransport.so" "${2}"
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
