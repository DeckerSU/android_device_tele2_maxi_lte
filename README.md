## [ROM][UNOFFICIAL][6.0.1] LineageOS 14 for Tele2 Maxi LTE ## (Decker, [http://www.decker.su](http://www.decker.su))

Заметки:
--------
[1] Временный фикс камеры с билдом libc с флагом -fno-stack-protector, чтобы избежать этого:

02-18 19:27:06.845   533   533 F DEBUG   : pid: 504, tid: 504, name: cameraserver  >>> /system/bin/cameraserver <<<
02-18 19:27:06.845   533   533 F DEBUG   : signal 6 (SIGABRT), code -6 (SI_TKILL), fault addr --------
02-18 19:27:06.846   357   488 E AudioALSAStreamOut: -getPresentationPosition(), no playback handler, *frames = 0, return
02-18 19:27:06.850   533   533 F DEBUG   : Abort message: 'stack corruption detected'
02-18 19:27:06.850   533   533 F DEBUG   :     r0 00000000  r1 000001f8  r2 00000006  r3 00000008
02-18 19:27:06.850   533   533 F DEBUG   :     r4 f71cc58c  r5 00000006  r6 f71cc534  r7 0000010c
02-18 19:27:06.850   533   533 F DEBUG   :     r8 f4520d58  r9 f451b4c0  sl f4520d54  fp f6cde008
02-18 19:27:06.850   533   533 F DEBUG   :     ip 00000005  sp ff9f38c0  lr f6c98ca7  pc f6c9b504  cpsr 200f0010
02-18 19:27:06.857   357   488 E AudioALSAStreamOut: -getPresentationPosition(), no playback handler, *frames = 0, return
02-18 19:27:06.859   533   533 F DEBUG   : 
02-18 19:27:06.859   533   533 F DEBUG   : backtrace:
02-18 19:27:06.859   533   533 F DEBUG   :     #00 pc 0004a504  /system/lib/libc.so (tgkill+12)
02-18 19:27:06.859   533   533 F DEBUG   :     #01 pc 00047ca3  /system/lib/libc.so (pthread_kill+34)
02-18 19:27:06.859   533   533 F DEBUG   :     #02 pc 0001d585  /system/lib/libc.so (raise+10)
02-18 19:27:06.859   533   533 F DEBUG   :     #03 pc 000190d1  /system/lib/libc.so (__libc_android_abort+34)
02-18 19:27:06.859   533   533 F DEBUG   :     #04 pc 00017138  /system/lib/libc.so (abort+4)
02-18 19:27:06.859   533   533 F DEBUG   :     #05 pc 0001b57f  /system/lib/libc.so (__libc_fatal+22)
02-18 19:27:06.859   533   533 F DEBUG   :     #06 pc 000489bb  /system/lib/libc.so (__stack_chk_fail+6)
02-18 19:27:06.859   533   533 F DEBUG   :     #07 pc 0001ab3b  /system/lib/libc.so (ioctl+66)
02-18 19:27:06.859   533   533 F DEBUG   :     #08 pc 00011981  /system/lib/libcam.halsensor.so (_ZN12ImgSensorDrv13getResolutionEPP34ACDK_SENSOR_RESOLUTION_INFO_STRUCT+60)
02-18 19:27:06.859   533   533 F DEBUG   :     #09 pc 0001335b  /system/lib/libcam.halsensor.so (_ZN12ImgSensorDrv4initEi+370)
02-18 19:27:06.860   533   533 F DEBUG   :     #10 pc 0000fec5  /system/lib/libcam.halsensor.so (_ZN5NSCam11NSHalSensor13HalSensorList18querySensorDrvInfoEv+28)
02-18 19:27:06.860   533   533 F DEBUG   :     #11 pc 0000fd2f  /system/lib/libcam.halsensor.so (_ZN5NSCam11NSHalSensor13HalSensorList22enumerateSensor_LockedEv+178)
02-18 19:27:06.860   533   533 F DEBUG   :     #12 pc 0000f95d  /system/lib/libcam.halsensor.so (_ZN5NSCam11NSHalSensor13HalSensorList13searchSensorsEv+14)
02-18 19:27:06.860   533   533 F DEBUG   :     #13 pc 000042b9  /system/lib/hw/camera.mt6737m.so (_ZN5NSCam19CamDeviceManagerImp16enumDeviceLockedEv+52)
02-18 19:27:06.860   533   533 F DEBUG   :     #14 pc 00004a23  /system/lib/hw/camera.mt6737m.so (_ZN5NSCam20CamDeviceManagerBase18getNumberOfDevicesEv+38)
02-18 19:27:06.860   533   533 F DEBUG   :     #15 pc 00060513  /system/lib/libcameraservice.so (_ZN7android12CameraModule18getNumberOfCamerasEv+58)
02-18 19:27:06.860   533   533 F DEBUG   :     #16 pc 0006041f  /system/lib/libcameraservice.so (_ZN7android12CameraModule4initEv+182)
02-18 19:27:06.861   533   533 F DEBUG   :     #17 pc 0004fd4d  /system/lib/libcameraservice.so (_ZN7android13CameraService10onFirstRefEv+100)
02-18 19:27:06.861   533   533 F DEBUG   :     #18 pc 00000be3  /system/bin/cameraserver
02-18 19:27:06.861   533   533 F DEBUG   :     #19 pc 00000b25  /system/bin/cameraserver
02-18 19:27:06.861   533   533 F DEBUG   :     #20 pc 00016cad  /system/lib/libc.so (__libc_init+48)
02-18 19:27:06.862   533   533 F DEBUG   :     #21 pc 00000a18  /system/bin/cameraserver

Подробнее:

https://github.com/danielhk/proprietary_vendor_lenovo_aio_otfp/commit/814c267a00ad5543dc9fe8e567913f484787df84

Thx, i already fixed stack corruption problem with another way. Don't need to write a camera wrapper, there is exists a simpy way with hack in libc ;) 
Open libc/Android.mk and add -fno-stack-protector to libc_common_cflags, after that there is no crash at ImgSensorDrv::getResolution() without any wrappers.

На будущее нужно будет писать camera wrapper, аналогичный вот этому:

https://github.com/danielhk/android_device_lenovo_aio_otfp/tree/cm-14.1/camera_wrapper
https://forum.xda-developers.com/k3-note/orig-development/rom-custom-nougat-roms-k-3-note-t3513466 (!!!)

---

stagefright: move MetadataRetriever off of OMXCodec
Also remove some unneeded OMXCodec includes.

https://github.com/LineageOS/android_frameworks_av/commit/6b0795009b8f53ab771e0074b76381977d016f4b

