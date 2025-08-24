# DISABLED = yes

HELP = compare permissions, capabilities, labels.. \
	between original and your custom ROM. Support for Android 14/15 "system_as_root"

ifeq ($(INSPECT_REPACKED_IMG), true)
INSPECT_SCR_CUSTOM := $(BCT.DIR)test/gen_perms_caps_labels_custom.sh
endif

define INSTALL
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/odm.$(LOCAL_SUFFIX)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/vendor.$(LOCAL_SUFFIX)
	$(INSPECT_SCR_CUSTOM) $(BCT.OUT)/system.$(LOCAL_SUFFIX)
endef
