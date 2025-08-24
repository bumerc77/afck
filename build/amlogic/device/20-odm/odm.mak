# DISABLED = yes

HELP = build $(MOD) sparse IMG Android 14/15, "system_as_root" only

# We apply the mod only after the unpack mod
DEPS += $(STAMP.unpack)

define INSTALL
	cd $(BCT.DIR) && ./build-pie build $(MOD) \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@echo -e "\nreplace old partition..."
	$(RM) $(IMG.IN)$(MOD).$(LOCAL_SUFFIX)
	cp $(BCT.OUT)/$(MOD).$(LOCAL_SUFFIX) $(IMG.IN) && sync
endef
