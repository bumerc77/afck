# DISABLED = yes

HELP = $(MOD) and dynamic partitions

DEPS += $(STAMP.unpack)

ifneq ($(MESON_DTB), true)
LOCAL_DTB := $(IMG.IN)_aml_dtb.PARTITION
else
LOCAL_DTB := $(IMG.IN)meson1.dtb
endif

define INSTALL
	@cd $(BCT.DIR) && ./resize-super $(PWD)/$(IMG.IN)$(SUPER_RAW) $(BCT.DIR) .stamp.mod-super
	@echo "replace old dtb..."
	$(RM) $(LOCAL_DTB)
	$(COPY) $(BCT.DIR)DTB $(LOCAL_DTB) && sync
endef
