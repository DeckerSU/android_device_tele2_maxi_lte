#!/bin/bash
cd ../../../..
cd system/core
git apply -v ../../device/tele2/maxi_lte/patches_decker/0001-Remove-CAP_SYS_NICE-from-surfaceflinger.patch
cd ../..
cd bionic
git apply -v ../device/tele2/maxi_lte/patches_decker/0002-Apply-LIBC-version-to-__pthread_gettid.patch
cd ..
cd system/sepolicy
git apply -v ../../device/tele2/maxi_lte/patches_decker/0003-Revert-back-to-policy-version-29.patch
cd ../..

