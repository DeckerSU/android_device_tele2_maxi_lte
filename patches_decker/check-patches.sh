#!/bin/bash
cd ../../../..
cd system/core
git apply -v --check ../../device/tele2/maxi_lte/patches_decker/0001-Remove-CAP_SYS_NICE-from-surfaceflinger.patch
git apply -v --check ../../device/tele2/maxi_lte/patches_decker/0004-libnetutils-add-MTK-bits-ifc_ccmni_md_cfg.patch
cd ../..
cd bionic
git apply -v --check ../device/tele2/maxi_lte/patches_decker/0002-Apply-LIBC-version-to-__pthread_gettid.patch
cd ..
cd system/sepolicy
git apply -v --check ../../device/tele2/maxi_lte/patches_decker/0003-Revert-back-to-policy-version-29.patch
cd ../..
cd packages/apps/Settings
git apply -v --check ../../../device/tele2/maxi_lte/patches_decker/0005-add-author-info-in-device-info.patch
cd ../../..

