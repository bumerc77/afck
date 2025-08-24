# DISABLED = yes

HELP = Resize partitions for old format packages "system_as_root", Android 12/13

DEPS += $(STAMP.unpack)

ifneq ($(MESON_DTB), true)
LOCAL_DTB := $(IMG.IN)_aml_dtb.PARTITION
else
LOCAL_DTB := $(IMG.IN)meson1.dtb
endif

define INSTALL
	cd $(BCT.DIR) && ./resize-pie
	@echo "replace old dtb..."
	$(RM) $(LOCAL_DTB)
	cp $(BCT.DIR)DTB $(LOCAL_DTB) && sync
endef
