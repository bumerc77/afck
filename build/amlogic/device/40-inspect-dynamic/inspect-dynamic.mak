# DISABLED = yes

HELP = compare permissions, capabilities, labels.. \
	between original and your custom ROM. Support for Android 14/15, new format package

ifeq ($(INSPECT_REPACKED_IMG), true)
INSPECT_SCR_CUSTOM := $(BCT.DIR)test/gen_perms_caps_labels_custom.sh
endif

define INSTALL
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/odm.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/vendor.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/product.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/system.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/system_ext.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/vendor_dlkm.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
endef
