(c) Decker, http://www.decker.su

###Что это?

Это дерево для сборки CyanogenMod / LineageOS / Mokee и некоторых других кастомных прошивок для Tele2 Maxi LTE. 

![Tele2 Maxi LTE / LineageOS](https://3.bp.blogspot.com/-beayt9o83QA/WKoDpc1PFoI/AAAAAAAAL-U/8NskvXvUNtI6ONDwmmB8jCojRD_XqGn6wCLcB/s1600/lineage_os_decker_su_478x269.jpg  "Tele2 Maxi LTE / LineageOS")

###Где можно почитать об альтернативных прошивках?

Вот здесь - [Tele2 Maxi LTE. Обзор альтернативных прошивок](http://www.decker.su/2017/02/tele2-maxi-lte-custom-firmwares.html) я постарался сделать небольшой обзор, а также выложить релизы прошивок в виде zip-архивов для установки через кастомный recovery (TWRP).

Обратие внимание, что если вы захотите собрать что-то из исходников этого дерева учитывайте что ветка **master** не является активной. Т.е. клонировать эту ветку не нужно, вместо этого в репе представлены еще несколько веток:

* cm-13.0
* lineage-13.0
* lineage-14.0
* mokee_mkn_mr1

Сборку следует производить на них. Т.е. клонируем device и vendor:

	git clone https://github.com/DeckerSU/android_device_tele2_maxi_lte -b имя_ветки device/tele2/maxi_lte
	git clone https://github.com/DeckerSU/android_vendor_tele2_maxi_lte -b имя_ветки vendor/tele2/maxi_lte

Внимательно читаем README.md и NOTES.md к данной ветке, применяем все патчи (!) и собираем. Особенное внимание следует уделить чтению комментариев в NOTES.md, в них приведены моменты, которые могут вам пригодиться.

В дереве работает все или практичеки всё, включая **GPS** и **запись видео** с камеры с помощью аппаратных OMX кодеков (даже на ветке CM14 / Lineage 14). 

В общей сложности на работу над этими деревьями и патчами были потрачены пара-тройка недель непрерывной работы (имеется ввиду суммарное время).

###Поддержка проекта

Если вы использовали данное дерево и успешно собрали прошивку для Maxi LTE или своего девайса на основе него, вы можете поддержать проект здесь - [http://donate.decker.su/](http://donate.decker.su/)  . Помните, что поддержка проекта является неплохой мотивацией для разрабтчиков и стимулом делать что-то в дальнейшем.

###Заметки

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
