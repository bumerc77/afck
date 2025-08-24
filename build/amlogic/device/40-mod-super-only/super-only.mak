# DISABLED = yes

HELP = build $(SUPER) only, Android 14/15

DEPS += $(STAMP.mod-unpack-super)

define INSTALL
	@cd $(BCT.DIR) && ./super-only $(PWD)/$(IMG.IN) $(LOCAL_SUFFIX) $(PWD)/$(BCT.OUT) $(SUPER_SPARSE) $(PWD)/$(BCT.DIR)
	@cd $(BCT.DIR) && ./build-super out super system system_ext vendor product vendor_dlkm odm $(IMG.IN)
	@echo -e "\n\033$(C.GREEN)build $(SUPER_SPARSE) done!\033[0m"
endef
