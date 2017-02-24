Здесь собраны некоторые заметки, просто для себя. Возможно они пригодятся вам при сборке прошивки, возможно, при работе над другими прошивками. Изначально я делал их в README.md, но потом решил вынести сюда, т.к. при просмотре ветки репозитория они слишком уж бросались в глаза и были там явно лишними.


###Фикс камеры

Временный фикс камеры с билдом libc с флагом -fno-stack-protector, чтобы избежать этого:

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


###Вибрация аппаратных клавиш


fix hardware keys vibration (make it virtual in mtk-tpd.lk)

Note #1: https://4pda.ru/forum/index.php?showtopic=411431&st=340
Note #2: frameworks/base/core/res/res/values/config.xml

CM13:

	    <!-- Vibrator pattern for feedback about touching a virtual key -->
	    <integer-array name="config_virtualKeyVibePattern">
	        <item>0</item>
	        <item>10</item>
	        <item>20</item>
	        <item>30</item>
	    </integer-array>

Stock:

	    <integer-array name="config_virtualKeyVibePattern">
		        <item>0</item>
		        <item>20</item>
		        <item>20</item>
	        <item>30</item>
	
Note #3:

	adb shell getevent
	/home/decker/cm-13.0/device/tele2/maxi_lte$ adb shell getevent
	add device 1: /dev/input/event6 
	  name:     "mtk-tpd-kpd" - отвечает за кнопки (!)
	add device 2: /dev/input/event5 
	  name:     "mtk-tpd"
	add device 3: /dev/input/event4 
	  name:     "m_acc_input" 
	add device 4: /dev/input/event3 
	  name:     "m_alsps_input" 
	add device 5: /dev/input/event2 
	  name:     "hwmdata" 
	add device 6: /dev/input/event0 
	  name:     "ACCDET" 
	add device 7: /dev/input/event1 
	  name:     "mtk-kpd" 

adb shell getevent /dev/input/event6

	(0x8b) 139 - квадрат (MENU)
	(0xac) 172 - круг (HOME)
	(0x9e) 158 - треугольник (BACK)
	
###	Отличия CM13 и CM14 в плане OMX кодеков


stagefright: move MetadataRetriever off of OMXCodec
Also remove some unneeded OMXCodec includes.

https://github.com/LineageOS/android_frameworks_av/commit/6b0795009b8f53ab771e0074b76381977d016f4b


###Патч Mediatek для system/core

system/core

	--- a/init/init.cpp
	+++ b/init/init.cpp
	@@ -85,7 +85,9 @@ static int have_console;
	 static char console_name[PROP_VALUE_MAX] = "/dev/console";
	 static time_t process_needs_restart;
	 
	-static const char *ENV[32];
	+// xen0n: some MTK services (e.g. ril-daemon-mtk) require very large number
	+// of sockets, which can't be contained in 32 entries minus other variables.
	+static const char *ENV[64];

### Количество устройств подключенных к WiFi AP

frameworks/base/services/core/java/com/android/server/connectivity/Tethering.java 	

Все достаточно просто, для определения количества устройсв в шторке разбирается файл dhcpLocation = "/data/misc/dhcp/dnsmasq.leases" в readDeviceInfoFromDnsmasq. Строки имеют вид а-ля:

	148763 f0:34:04:7e:42:1e 192.168.43.158 android-8f240c13289d40dd 01:f0:34:04:7e:42:1e
	
Ну и потом общее количество устройсв вычисляется как int size = mConnectedDeviceMap.size(); ... вот только почему-то судя по тому что в шторке отображается ноль устройств, mConnectedDeviceMap заполняется как-то некорректно. Включил отладочный лог:

	    private final static String TAG = "Tethering";
	    private final static boolean DBG = true;
	    private final static boolean VDBG = true;
    
Посмотрим что к чему.
    
При подключении клиента или любой смене активности интерфейса ap0 вызывается:

	    public void interfaceStatusChanged(String iface, boolean up) {
	        // Never called directly: only called from interfaceLinkStateChanged.
	        // See NetlinkHandler.cpp:71.
	        if (VDBG) Log.d(TAG, "interfaceStatusChanged " + iface + ", " + up);
	        synchronized (mPublicSync) {
	            int interfaceType = ifaceNameToType(iface);
	            if (interfaceType == ConnectivityManager.TETHERING_INVALID) {
	                return;
	            }
    
А в логе мы видим что-то вроде:

	02-21 01:41:14.229   621   792 D Tethering: interfaceStatusChanged ap0, true 
	02-21 01:42:13.112   621   792 D Tethering: interfaceStatusChanged ap0, true 
	02-21 01:42:22.456   621   792 D Tethering: interfaceStatusChanged ap0, true 
	
Видимо потому что тип интерфейса приходит в состояние ConnectivityManager.TETHERING_INVALID, вернее ifaceNameToType возвращает его таким. А должно быть по идее ConnectivityManager.TETHERING_WIFI.  Что ж, посмотрим и в нее:

	    private int ifaceNameToType(String iface) {
	        if (isWifi(iface)) {
	            return ConnectivityManager.TETHERING_WIFI; // (0)
	        } else if (isUsb(iface)) {
	            return ConnectivityManager.TETHERING_USB; // (1)
	        } else if (isBluetooth(iface)) {
	            return ConnectivityManager.TETHERING_BLUETOOTH; // (2)
	        }
	        return ConnectivityManager.TETHERING_INVALID; // (-1)
	    }
	
Ага ... значит вызывается isWifi(iface), т.е. в нашем случае isWifi("ap0") ... глянем еще глубже ;)

	    private boolean isWifi(String iface) {
	        synchronized (mPublicSync) {
	            for (String regex : mTetherableWifiRegexs) {
	                if (iface.matches(regex)) return true;
	            }
	            return false;
	        }
	    }

Ага ... значит имя интерфейса сверяется с regexp'ом ... и еще чуть глубже:

mTetherableWifiRegexs <-- tetherableWifiRegexs, где последнее берется как:

            tetherableWifiRegexs = mContext.getResources().getStringArray(
                com.android.internal.R.array.config_tether_wifi_regexs);

Ну собственно а кто против, давайте найдем и его.

Ага:

frameworks/base/core/res/res/values/config.xml 

	    <string-array translatable="false" name="config_tether_wifi_regexs">
	    </string-array>
	    
Чего здесь не хватает? Правильно. Нашего **ap0** ...

Добавляем в device/tele2/maxi_lte/overlay/frameworks/base/core/res/res/values/config.xml строки:

	    <string-array translatable="false" name="config_tether_wifi_regexs">
	        <item>ap\\d</item>
	    </string-array>

Но ... шторка все равно пустая ... т.е. как было 0 подключений, так и осталось, даже при подключенных устройствах ...

Ну по-крайней мере у нас теперь isWiFi("ap0") возвращает true, но **проблема все еще не решена** :((

###VP9 OMX Decoder

Original CM 14.1 Sources:

	typedef enum OMX_COLOR_FORMATTYPE {
	    OMX_COLOR_FormatUnused, /* 0x00 */
	    OMX_COLOR_FormatMonochrome, /* 0x01 */
	    OMX_COLOR_Format8bitRGB332, /* 0x02 */
	    OMX_COLOR_Format12bitRGB444, /* 0x03 */
	    OMX_COLOR_Format16bitARGB4444, /* 0x04 */
	    OMX_COLOR_Format16bitARGB1555, /* 0x05 */
	    OMX_COLOR_Format16bitRGB565, /* 0x06 */
	    OMX_COLOR_Format16bitBGR565, /* 0x07 */
	    OMX_COLOR_Format18bitRGB666, /* 0x08 */
	    OMX_COLOR_Format18bitARGB1665, /* 0x09 */
	    OMX_COLOR_Format19bitARGB1666, /* 0x0A */
	    OMX_COLOR_Format24bitRGB888, /* 0x0B */
	    OMX_COLOR_Format24bitBGR888, /* 0x0C */
	    OMX_COLOR_Format24bitARGB1887, /* 0x0D */
	    OMX_COLOR_Format25bitARGB1888, /* 0x0E */
	    OMX_COLOR_Format32bitBGRA8888, /* 0x0F */
	    OMX_COLOR_Format32bitARGB8888, /* 0x10 */
	    OMX_COLOR_FormatYUV411Planar, /* 0x11 */
	    OMX_COLOR_FormatYUV411PackedPlanar, /* 0x12 */
	    OMX_COLOR_FormatYUV420Planar, /* 0x13 */
	    OMX_COLOR_FormatYUV420PackedPlanar, /* 0x14 */
	    OMX_COLOR_FormatYUV420SemiPlanar, /* 0x15 */
	    OMX_COLOR_FormatYUV422Planar, /* 0x16 */
	    OMX_COLOR_FormatYUV422PackedPlanar, /* 0x17 */
	    OMX_COLOR_FormatYUV422SemiPlanar, /* 0x18 */
	    OMX_COLOR_FormatYCbYCr, /* 0x19 */
	    OMX_COLOR_FormatYCrYCb, /* 0x1A */
	    OMX_COLOR_FormatCbYCrY, /* 0x1B */
	    OMX_COLOR_FormatCrYCbY, /* 0x1C */
	    OMX_COLOR_FormatYUV444Interleaved, /* 0x1D */
	    OMX_COLOR_FormatRawBayer8bit, /* 0x1E */
	    OMX_COLOR_FormatRawBayer10bit, /* 0x1F */
	    OMX_COLOR_FormatRawBayer8bitcompressed, /* 0x20 */
	    OMX_COLOR_FormatL2, /* 0x21 */
	    OMX_COLOR_FormatL4, /* 0x22 */
	    OMX_COLOR_FormatL8, /* 0x23 */
	    OMX_COLOR_FormatL16,
	    OMX_COLOR_FormatL24,
	    OMX_COLOR_FormatL32,
	    OMX_COLOR_FormatYUV420PackedSemiPlanar,
	    OMX_COLOR_FormatYUV422PackedSemiPlanar,
	    OMX_COLOR_Format18BitBGR666,
	    OMX_COLOR_Format24BitARGB6666,
	    OMX_COLOR_Format24BitABGR6666,
	    OMX_COLOR_FormatKhronosExtensions = 0x6F000000, /**< Reserved region for introducing Khronos Standard Extensions */
	    OMX_COLOR_FormatVendorStartUnused = 0x7F000000, /**< Reserved region for introducing Vendor Extensions */
	    /**<Reserved android opaque colorformat. Tells the encoder that
	     * the actual colorformat will be  relayed by the
	     * Gralloc Buffers.
	     * FIXME: In the process of reserving some enum values for
	     * Android-specific OMX IL colorformats. Change this enum to
	     * an acceptable range once that is done.
	     * */
	    OMX_COLOR_FormatAndroidOpaque = 0x7F000789,
	    OMX_COLOR_Format32BitRGBA8888 = 0x7F00A000,
	    /** Flexible 8-bit YUV format.  Codec should report this format
	     *  as being supported if it supports any YUV420 packed planar
	     *  or semiplanar formats.  When port is set to use this format,
	     *  codec can substitute any YUV420 packed planar or semiplanar
	     *  format for it. */
	    OMX_COLOR_FormatYUV420Flexible = 0x7F420888,
	
	    OMX_TI_COLOR_FormatYUV420PackedSemiPlanar = 0x7F000100,
	    OMX_QCOM_COLOR_FormatYVU420SemiPlanar = 0x7FA30C00,
	    OMX_QCOM_COLOR_FormatYUV420PackedSemiPlanar64x32Tile2m8ka = 0x7FA30C03,
	    OMX_SEC_COLOR_FormatNV12Tiled = 0x7FC00002,
	    OMX_QCOM_COLOR_FormatYUV420PackedSemiPlanar32m = 0x7FA30C04,
	    OMX_COLOR_FormatMax = 0x7FFFFFFF
	} OMX_COLOR_FORMATTYPE;
	

MTK Sources:

**vendor/mediatek/proprietary/frameworks/native/include/media/openmax/OMX_IVCommon.h **

	typedef enum OMX_COLOR_FORMATTYPE {
	    OMX_COLOR_FormatUnused,
	    OMX_COLOR_FormatMonochrome,
	    OMX_COLOR_Format8bitRGB332,
	    OMX_COLOR_Format12bitRGB444,
	    OMX_COLOR_Format16bitARGB4444,
	    OMX_COLOR_Format16bitARGB1555,
	    OMX_COLOR_Format16bitRGB565,
	    OMX_COLOR_Format16bitBGR565,
	    OMX_COLOR_Format18bitRGB666,
	    OMX_COLOR_Format18bitARGB1665,
	    OMX_COLOR_Format19bitARGB1666,
	    OMX_COLOR_Format24bitRGB888,
	    OMX_COLOR_Format24bitBGR888,
	    OMX_COLOR_Format24bitARGB1887,
	    OMX_COLOR_Format25bitARGB1888,
	    OMX_COLOR_Format32bitBGRA8888,
	    OMX_COLOR_Format32bitARGB8888,
	    OMX_COLOR_FormatYUV411Planar,
	    OMX_COLOR_FormatYUV411PackedPlanar,
	    OMX_COLOR_FormatYUV420Planar,
	    OMX_COLOR_FormatYUV420PackedPlanar,
	    OMX_COLOR_FormatYUV420SemiPlanar,
	    OMX_COLOR_FormatYUV422Planar,
	    OMX_COLOR_FormatYUV422PackedPlanar,
	    OMX_COLOR_FormatYUV422SemiPlanar,
	    OMX_COLOR_FormatYCbYCr,
	    OMX_COLOR_FormatYCrYCb,
	    OMX_COLOR_FormatCbYCrY,
	    OMX_COLOR_FormatCrYCbY,
	    OMX_COLOR_FormatYUV444Interleaved,
	    OMX_COLOR_FormatRawBayer8bit,
	    OMX_COLOR_FormatRawBayer10bit,
	    OMX_COLOR_FormatRawBayer8bitcompressed,
	    OMX_COLOR_FormatL2,
	    OMX_COLOR_FormatL4,
	    OMX_COLOR_FormatL8,
	    OMX_COLOR_FormatL16,
	    OMX_COLOR_FormatL24,
	    OMX_COLOR_FormatL32,
	    OMX_COLOR_FormatYUV420PackedSemiPlanar,
	    OMX_COLOR_FormatYUV422PackedSemiPlanar,
	    OMX_COLOR_Format18BitBGR666,
	    OMX_COLOR_Format24BitARGB6666,
	    OMX_COLOR_Format24BitABGR6666,
	    OMX_COLOR_FormatKhronosExtensions = 0x6F000000, /**< Reserved region for introducing Khronos Standard Extensions */
	    OMX_COLOR_FormatVendorStartUnused = 0x7F000000, /**< Reserved region for introducing Vendor Extensions */
	    OMX_COLOR_FormatVendorMTKYUV = 0x7F000001,
	    OMX_COLOR_FormatVendorMTKYUV_FCM = 0x7F000002,
	    OMX_COLOR_FormatVendorMTKYUV_UFO = 0x7F000003,
	    OMX_COLOR_FormatVendorMTKYUV_10BIT_H = 0x7F000004,
	    OMX_COLOR_FormatVendorMTKYUV_10BIT_V = 0x7F000005,
	    OMX_COLOR_FormatVendorMTKYUV_UFO_10BIT_H = 0x7F000006,
	    OMX_COLOR_FormatVendorMTKYUV_UFO_10BIT_V = 0x7F000007,
	    /**<Reserved android opaque colorformat. Tells the encoder that
	     * the actual colorformat will be  relayed by the
	     * Gralloc Buffers.
	     * FIXME: In the process of reserving some enum values for
	     * Android-specific OMX IL colorformats. Change this enum to
	     * an acceptable range once that is done.
	     * */
	    OMX_COLOR_FormatAndroidOpaque = 0x7F000789,
	    OMX_COLOR_Format32BitRGBA8888 = 0x7F00A000,
	    /** Flexible 8-bit YUV format.  Codec should report this format
	     *  as being supported if it supports any YUV420 packed planar
	     *  or semiplanar formats.  When port is set to use this format,
	     *  codec can substitute any YUV420 packed planar or semiplanar
	     *  format for it. */
	    OMX_COLOR_FormatYUV420Flexible = 0x7F420888,
	
	    OMX_TI_COLOR_FormatYUV420PackedSemiPlanar = 0x7F000100,
	    OMX_MTK_COLOR_FormatYV12 = 0x7F000200,
	    OMX_MTK_COLOR_FormatBitStream = 0x7F000300,
	    OMX_QCOM_COLOR_FormatYVU420SemiPlanar = 0x7FA30C00,
	    OMX_QCOM_COLOR_FormatYUV420PackedSemiPlanar64x32Tile2m8ka = 0x7FA30C03,
	    OMX_SEC_COLOR_FormatNV12Tiled = 0x7FC00002,
	    OMX_QCOM_COLOR_FormatYUV420PackedSemiPlanar32m = 0x7FA30C04,
	    OMX_COLOR_FormatMax = 0x7FFFFFFF
	} OMX_COLOR_FORMATTYPE;


...

ACodec.cpp:


	02-24 19:58:46.442   362   430 D MtkOmxVdecEx: [0xf4cd9000] mOutputPortDef eColorFormat(13), eColorFormat(7f000200), meDecodeType(1), mForceOutputBufferCount(0), mIsUsingNativeBuffers(1)
	02-24 19:58:46.442   362   430 D MtkOmxVdecEx: [0xf4cd9000] [STANDARD][HAL_PIXEL_FORMAT_YV12] -> HAL_PIXEL_FORMAT_YCbCr_420_888
	02-24 19:58:46.442   362   430 D MtkOmxVdecEx: [0xf4cd9000] 32x32 Aligned! mOutputPortDef.nBufferSize(369600), nStride(640), nSliceHeight(384) nBufferCountActual(11)
	02-24 19:58:46.443   362  1047 D MtkOmxVdecEx: [0xf4cd9000] GP (0x7F000006)
	02-24 19:58:46.444  2762  3109 E ACodec  : [Decker] b: setHalWindowColorFormat(0x23) - OMX.MTK.VIDEO.DECODER.VP9
	02-24 19:58:46.444  2762  3109 E ACodec  : [Decker] e: setHalWindowColorFormat(0x32315669) - OMX.MTK.VIDEO.DECODER.VP9
	02-24 19:58:46.445  2762  3109 D SurfaceUtils: set up nativeWindow 0x7f89590810 for 640x360, color 0x32315669, rotation 0, usage 0x2933
	
...

В итоге помог такой временный патч в frameworks/av/media/libstagefright/ACodec.cpp :


	#define HAL_PIXEL_FORMAT_NV12_BLK 0x7F000001
	#define HAL_PIXEL_FORMAT_I420 (0x32315659 + 0x10)
	#define HAL_PIXEL_FORMAT_YUV_PRIVATE (0x32315659 + 0x20)

И:

	#ifdef MTK_HARDWARE
	void ACodec::setHalWindowColorFormat(OMX_COLOR_FORMATTYPE &eHalColorFormat) {
	    ALOGE("[Decker] setHalWindowColorFormat(%#x) - %s",eHalColorFormat,mComponentName.c_str());
	
	    if (!strncmp("OMX.MTK.", mComponentName.c_str(), 8)) {
	        switch (eHalColorFormat) {
	            case OMX_COLOR_FormatYUV420Planar:
	                eHalColorFormat = (OMX_COLOR_FORMATTYPE)HAL_PIXEL_FORMAT_I420;
	                break;
	            case OMX_MTK_COLOR_FormatYV12:
	                eHalColorFormat = (OMX_COLOR_FORMATTYPE)HAL_PIXEL_FORMAT_YV12;
	                break;
	            case OMX_COLOR_FormatVendorMTKYUV:
	                eHalColorFormat = (OMX_COLOR_FORMATTYPE)HAL_PIXEL_FORMAT_NV12_BLK;
	                break;
	            default:
			if (!strcasecmp(mComponentName.c_str(), "OMX.MTK.VIDEO.DECODER.VP9")) {
				ALOGE("[Decker] OMX.MTK.VIDEO.DECODER.VP9 detected ... change Hal Color Format ...");
				eHalColorFormat = (OMX_COLOR_FORMATTYPE)HAL_PIXEL_FORMAT_YUV_PRIVATE;
			} else
	                eHalColorFormat = (OMX_COLOR_FORMATTYPE)HAL_PIXEL_FORMAT_I420;
	
	                break;
	        }
	    }
	}
	#endif

Т.е. фактически мы объявили новый eHalColorFormat = HAL_PIXEL_FORMAT_YUV_PRIVATE и в setHalWindowColorFormat, который уже был добавлен в одном из патчей сделали проверку, если декодирование у нас осуществляется с помощью OMX.MTK.VIDEO.DECODER.VP9, то устанавливаем eHalColorFormat как HAL_PIXEL_FORMAT_YUV_PRIVATE.

Напомню что HAL_PIXEL_FORMAT_YUV_PRIVATE объявлен в ALPS в vendor/mediatek/proprietary/hardware/gralloc_extra/include/graphics_mtk_defs.h как:

	HAL_PIXEL_FORMAT_YUV_PRIVATE    = 0x32315659 + 0x20,                 /// I420 or NV12_BLK or NV12_BLK_FCM


