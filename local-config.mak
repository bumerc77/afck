# MOD directory
TARGET = amlogic/device

# Android codename (14 = Upside Down Cake, 15 = Vanila Ice Crem)
A.CN = VIC

# AML img package name (Required for mod-extract-zip)
IMG.BASE += aml_install_package.img

## Lineage-*.zip name
LINEAGE_ZIP = ingredients/lineage-22.2-20251130-nightly-m5-signed.zip

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

# Partition suffix
ifeq ($(TARGET_HAS_DYNAMIC_PART), true)
LOCAL_SUFFIX := img
else
LOCAL_SUFFIX := PARTITION
endif

# Dtb name
ifneq ($(MESON_DTB), true)
LOCAL_DTB += $(IMG.IN)_aml_dtb.PARTITION
else
LOCAL_DTB += $(IMG.IN)meson1.dtb
endif

# FS check
ifeq ($(INSPECT_REPACKED_IMG), true)
INSPECT_SCR_STOCK += $(BCT.DIR)test/gen_perms_caps_labels_stock.sh
endif

include bc-tool/cleanup.mak
