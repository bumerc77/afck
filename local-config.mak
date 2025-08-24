# MOD directory
TARGET = amlogic/device

# Android codename (14 = Upside Down Cake, 15 = Vanila Ice Crem)
A.CN = VIC

# Support dynamic partitions
TARGET_HAS_DYNAMIC_PART ?= true

# MOD inspect
INSPECT_REPACKED_IMG ?= true

# Support meson1.dtb (By default in LineageOS images)
# Set this parameter to "false" if _aml_dtb.PARTITION is used as the default dtb file
MESON_DTB ?= true

SUPER = super.PARTITION

SUPER_RAW = $(SUPER).raw

SUPER_SPARSE = super.$(LOCAL_SUFFIX)

ifeq ($(TARGET_HAS_DYNAMIC_PART), true)
LOCAL_SUFFIX := img
else
LOCAL_SUFFIX := PARTITION
endif

include bc-tool/cleanup.mak
