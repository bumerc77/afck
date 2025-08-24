# DISABLED = yes

HELP = compile sepolicy "system_as_root"

define INSTALL
	cd $(BCT.DIR) && ./compile-sepolicy $(PWD)/$(IMG.IN)$(SUPER_RAW) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)
endef
