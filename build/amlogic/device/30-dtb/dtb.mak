# DISABLED = yes

HELP = compile single or multi $(MOD)

DEPS += $(STAMP.mod-dts)

define INSTALL
	cd $(BCT.DIR) && ./compile-$(MOD) dts dtb
	@echo "replace old $(MOD)..."
	$(RM) $(LOCAL_DTB)
	cp $(BCT.DIR)DTB $(LOCAL_DTB) && sync
endef
