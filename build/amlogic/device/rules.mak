# IMG name
FIRMNAME = LineageOS-22.2
# Название целевого устройства (без пробелов)
DEVICE = amlogic
# Вариант прошивки, значение по умолчанию
VARIANT = $(A.CN)
# Platform (ro.product.device)
PRODEV = g12a
# IMG package name
IMG.BASE = aml_upgrade_package.img
# vendor partition size (Android 8)
EXT4.SIZE.vendor=335544320

# Предпочтительная архитектура для библиотек в устанавливаемых APK
# (через пробел в порядке уменьшения приоритета)
APKARCH=armeabi-v7a armeabi

# Добавляем суффикс к каталогу OUT в зависимости от варианта прошивки
OUT := $(OUT)$(VARIANT)/

# Правила для вычисления номера версии
include build/version.mak

# Добавляем правила распаковки исходного образа
include build/img-amlogic-unpack.mak

# # file_contexts (AOSP 14/15)
FILE_CONTEXTS.product = $(PRODUCT)etc/selinux/*file_contexts
FILE_CONTEXTS.vendor = $(VENDOR)etc/selinux/*file_contexts
FILE_CONTEXTS.system = $(SYSTEM)system/etc/selinux/*file_contexts

ifeq ($(TARGET_HAS_DYNAMIC_PART),true)
FILE_CONTEXTS.system_ext = $(SYSTEM_EXT)etc/selinux/*file_contexts
else
FILE_CONTEXTS.system_ext = $(SYSTEM)system/system_ext/etc/selinux/*file_contexts
endif

# sepolicy sha256sum files (AOSP 14/15)
FILE_SHA256.system = $(HOME.DIR)system/system/etc/selinux/*sha256
FILE_SHA256_PLATFORM.odm = $(HOME.DIR)odm/etc/selinux/*plat_sepolicy_and_mapping.sha256

ifeq ($(TARGET_HAS_DYNAMIC_PART),true)
FILE_SHA256.system_ext = $(HOME.DIR)system_ext/etc/selinux/*.sha256
FILE_SHA256.product = $(HOME.DIR)product/etc/selinux/*.sha256
else
FILE_SHA256.system_ext = $(HOME.DIR)system/system/system_ext/etc/selinux/*sha256
FILE_SHA256.system_ext = $(HOME.DIR)system/system/product/etc/selinux/*sha256
endif

FILE_SHA256_SYSTEM_EXT.odm = $(HOME.DIR)odm/etc/selinux/*system_ext_sepolicy_and_mapping.sha256
FILE_SHA256_PRODUCT.odm = $(HOME.DIR)odm/etc/selinux/*product_sepolicy_and_mapping.sha256

# sepolicy files (AOSP 14/15)
PRECOMPILED_SEPOLICY = $(HOME.DIR)odm/etc/selinux/precompiled_sepolicy

CIL_FILE_SYSTEM = $(HOME.DIR)system/system/etc/selinux/plat_sepolicy.cil
CIL_FILE_VENDOR = $(HOME.DIR)vendor/etc/selinux/vendor_sepolicy.cil

ifeq ($(TARGET_HAS_DYNAMIC_PART),true)
CIL_FILE_PRODUCT = $(HOME.DIR)product/etc/selinux/product_sepolicy.cil
CIL_FILE_SYSTEM_EXT = $(HOME.DIR)system_ext/etc/selinux/system_ext_sepolicy.cil
else
CIL_FILE_PRODUCT = $(HOME.DIR)system/system/product/etc/selinux/product_sepolicy.cil
CIL_FILE_SYSTEM_EXT = $(HOME.DIR)system/system/system_ext/etc/selinux/system_ext_sepolicy.cil
endif

FILE_CONTEXTS.DEP += $(IMG.OUT).stamp.unpack-system_ext \
                     $(IMG.OUT).stamp.unpack-system \
                     $(IMG.OUT).stamp.unpack-vendor\
                     $(IMG.OUT).stamp.unpack-vendor_dlkm\
                     $(IMG.OUT).stamp.unpack-odm \
                     $(IMG.OUT).stamp.unpack-product \
                     $(IMG.OUT).stamp.unpack-system_ext_dynamic \
                     $(IMG.OUT).stamp.unpack-system_dynamic \
                     $(IMG.OUT).stamp.unpack-vendor_dynamic\
                     $(IMG.OUT).stamp.unpack-odm_dynamic \
                     $(IMG.OUT).stamp.unpack-product_dynamic \
                     $(IMG.OUT).stamp.unpack-unpack_super

# Теперь правила для наложения модификаций
include build/mod.mak

# Правила упаковки конечного образа
include build/img-amlogic-pack.mak

# Также мы хотим образ для прошивки через Recovery
UPD.PART = odm product vendor system boot _aml_dtb
include build/recovery-pack.mak

# Список файлов, которые попадают в релиз
DEPLOY = $(UBT.IMG) $(UPD.ZIP)

# Правила для сборки релиза
include build/deploy.mak
