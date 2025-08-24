# DISABLED = yes

HELP = build odm product vendor system sparse IMG Android-15, "system_as_root" only

# We apply the mod only after the unpack mod
DEPS += $(STAMP.mod-unpack)

define INSTALL
	cd $(BCT.DIR) && ./build-pie build odm \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)
	@echo ""
	cd $(BCT.DIR) && ./build-pie build vendor \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)
	@echo ""
	cd $(BCT.DIR) && ./build-pie build system \
	$(PRECOMPILED_SEPOLICY) $(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@echo -e "\nreplace old partitions..."
	$(RM) $(IMG.IN)odm.$(LOCAL_SUFFIX)
	$(RM) $(IMG.IN)vendor.$(LOCAL_SUFFIX)
	$(RM) $(IMG.IN)system.$(LOCAL_SUFFIX)

	cp $(BCT.OUT)/odm.$(LOCAL_SUFFIX) $(IMG.IN) && sync
	cp $(BCT.OUT)/vendor.$(LOCAL_SUFFIX) $(IMG.IN) && sync
	cp $(BCT.OUT)/system.$(LOCAL_SUFFIX) $(IMG.IN) && sync
endef
