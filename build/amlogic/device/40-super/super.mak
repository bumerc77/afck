# DISABLED = yes

HELP = build dynamic (raw) partitions and $(MOD).img (sparse), Android 14/15

DEPS += $(STAMP.mod-unpack-$(MOD))

define INSTALL
	@cd $(BCT.DIR) && ./build-dynamic build system $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-dynamic build vendor $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-dynamic build vendor_dlkm $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-dynamic build odm $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-dynamic build product $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-dynamic build system_ext $(IMG.IN) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@cd $(BCT.DIR) && ./build-$(MOD) out $(MOD) system vendor vendor_dlkm odm product system_ext $(IMG.IN)
	@echo -e "\n\033$(C.GREEN)build $(SUPER) done!\033[0m"
endef
