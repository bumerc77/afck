# DISABLED = yes

HELP = build $(MOD) partition, Android 14/15

DEPS += $(STAMP.mod-unpack-$(MOD))

define INSTALL
	@cd $(BCT.DIR) && ./build-dynamic build odm $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)
endef
