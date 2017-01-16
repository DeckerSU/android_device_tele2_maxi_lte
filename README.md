Заметки
-------

[1] https://github.com/DeckerSU/android_device_smart_surf2_4g/blob/master/README.md - основные заметки по сборке можно найти здесь, более 
того, не прочитав и не вникнув в них вряд-ли вам удастся собрать что-то рабочее.

[2] https://forum.xda-developers.com/k3-note/orig-development/rom-custom-nougat-roms-k-3-note-t3513466 - III. The Camera
After my first ROM was out, the most eye catching in the log would be the stack corruption in libcam.halsensor.so. 

https://github.com/danielhk/android_device_lenovo_aio_otfp - ссылка на дерево девайса, про который пишет автор.
https://github.com/danielhk/android_device_lenovo_aio_otfp/tree/9897899ab54fb70d36ee420f7cef3bf87cad7ace/camera_wrapper

Проблема с камерой, описанная по ссылке выше по всей видимости полностью аналогична проблеме с камерой в Tele2 Maxi LTE.

[3] Два патча system/core для символов MTK еще не включены в apply_patch:

0003-Add-depreciated-symbols-needed-by-old-mali-blobs.patch
0004-libnetutils-add-MTK-bits.patch

Поэтому применить их нужно вручную.

[4] libc/Android.mk

    libc_common_cflags := \
        -D_LIBC=1 \
        -Wall -Wextra -Wunused \
        -fno-stack-protector 

А вот этот хак с fno-stack-protector в libc позволяет заставить работать blob libcam.halsensor.so от камеры так,
как нужно ;)

[5] Добавляем полноценную поддержку 64-bit режима:

В BoardConfig.mk:

Без нижеследующих трех строк 64-битные компоненты соберутся, однако при старте прошивки все равно
будут использоваться 32-битные бинарники. Например, Antutu Benchmark будет отображать 
прошивку как 32-битную.

    TARGET_CPU_ABI_LIST_64_BIT := $(TARGET_CPU_ABI)
    TARGET_CPU_ABI_LIST_32_BIT := $(TARGET_2ND_CPU_ABI),$(TARGET_2ND_CPU_ABI2)
    TARGET_CPU_ABI_LIST := $(TARGET_CPU_ABI_LIST_64_BIT),$(TARGET_CPU_ABI_LIST_32_BIT)

И в device_maxi_lte.mk ддя поддержки 64-bit zygote:

Inherit from core_64_bit
This triggers intialization of the 64-bit zygote, we were previously
running the app runtime in 32-bit only which meant that some apps that
only have 64-bit jni dependencies weren't actually working correctly.

Нужно еще раскомментировать:

    #$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

И возможно:

    #$(call inherit-product, build/target/product/aosp_arm64.mk)
