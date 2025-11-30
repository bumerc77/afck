# DISABLED = yes

HELP = $(MOD), LineageOS-22.1/22.2 ZIP-Install-Package

DEPS += $(IMG.IN).stamp.unpack

define INSTALL
	@echo -e "\n\033$(C.YELLOW)$(MOD):\033[0m"
	@cd $(BCT.DIR) && ./$(MOD) $(SUPER) $(PWD)/$(LINEAGE_ZIP) \
	$(PWD)/$(IMG.IN) $(PWD)/$(BCT.DIR) $(SDAT2IMG)sdat2img.py $(PART.TABLE)part_table

	@echo -e "\n\033$(C.YELLOW)Copy dtb:\033[0m"
	$(COPY) $(LOCAL_DTB) $(BCT.DIR)DTB

	mkdir -p $(SELINUX)

	@echo -e "\n\033$(C.YELLOW)Unpack partitions:\033[0m"
	$(TOOLS.DIR)ext4unpack $(IMG.IN)odm.$(LOCAL_SUFFIX) $(ODM)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)vendor.$(LOCAL_SUFFIX) $(VENDOR)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)vendor_dlkm.$(LOCAL_SUFFIX) $(VENDOR_DLKM)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)product.$(LOCAL_SUFFIX) $(PRODUCT)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)system_ext.$(LOCAL_SUFFIX) $(SYSTEM_EXT)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)system.$(LOCAL_SUFFIX) $(SYSTEM)

	@echo -e "\n\033$(C.YELLOW)Copy file_contexts:\033[0m"
	$(COPY) $(FILE_CONTEXTS.vendor) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.product) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.system_ext) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.system) $(SELINUX)

	@cat $(TARGET.DIR)40-unpack-super/system_contexts >> $(SELINUX)plat_file_contexts
	@cat $(TARGET.DIR)40-unpack-super/vendor_contexts >> $(SELINUX)vendor_file_contexts

	@echo -e "\n\033$(C.YELLOW)Filesystem check:\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)odm.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)vendor.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)vendor_dlkm.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)product.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)system.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)system_ext.$(LOCAL_SUFFIX) $(IMG.IN)$(SUPER_RAW)
	@echo -e "\033$(C.HEAD)ok\033[0m"

	@echo -e "\n\033$(C.YELLOW)Timestamp:\033[0m"
	@cd $(BCT.DIR) && ./merge-timestamp $(PRECOMPILED_SEPOLICY) \
	$(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	@$(RMDIR) $(IMG.OUT)*

	@echo -e "\n\033$(C.HEAD)$(MOD) done!\033[0m"
endef

define DESC
* Extract lineage-*.zip
endef
