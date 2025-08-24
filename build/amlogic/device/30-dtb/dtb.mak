# DISABLED = yes

HELP = compile single or multi $(MOD)

DEPS += $(STAMP.mod-dts)

ifeq ($(MESON_DTB), true)
LOCAL_DTB := $(IMG.IN)meson1.$(MOD)
else
LOCAL_DTB := $(IMG.IN)_aml_$(MOD).PARTITION
endif

define INSTALL
	cd $(BCT.DIR) && ./compile-$(MOD) dts dtb
	@echo "replace old $(MOD)..."
	$(RM) $(LOCAL_DTB)
	cp $(BCT.DIR)DTB $(LOCAL_DTB) && sync
endef
