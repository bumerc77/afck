# DISABLED = yes

HELP = $(MOD) $(IMG.BASE) Android 14/15 - "system_as_root" only

DEPS += $(IMG.IN).stamp.unpack

$(call IMG.UNPACK.EXT4,odm)
$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	mkdir -p $(SELINUX)

	@echo -e "\n\033$(C.YELLOW)Unpack partitions:\033[0m"
	$(TOOLS.DIR)ext4unpack $(IMG.IN)vendor.$(LOCAL_SUFFIX) $(VENDOR)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)odm.$(LOCAL_SUFFIX) $(ODM)
	$(TOOLS.DIR)ext4unpack $(IMG.IN)system.$(LOCAL_SUFFIX) $(SYSTEM)

	@echo -e "\n\033$(C.YELLOW)Copy dtb:\033[0m"
	$(COPY) $(LOCAL_DTB) $(BCT.DIR)DTB && sync

	@echo -e "\n\033$(C.YELLOW)Copy file_contexts:\033[0m"
	$(COPY) $(FILE_CONTEXTS.product) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.vendor) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.system) $(SELINUX)
	$(COPY) $(FILE_CONTEXTS.system_ext) $(SELINUX)

	@cat $(DIR)contexts >> $(SELINUX)plat_file_contexts

	@echo -e "\n\033$(C.YELLOW)Filesystem check:\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)odm.$(LOCAL_SUFFIX)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)vendor.$(LOCAL_SUFFIX)
	@echo -e "\033$(C.HEAD)ok\033[0m"
	$(INSPECT_SCR_STOCK) $(IMG.IN)system.$(LOCAL_SUFFIX)
	@echo -e "\033$(C.HEAD)ok\033[0m"

	@echo -e "\n\033$(C.YELLOW)Timestamp\033[0m"
	cd $(BCT.DIR) && ./merge_timestamp $(PRECOMPILED_SEPOLICY) \
	$(CIL_FILE_SYSTEM) $(CIL_FILE_SYSTEM_EXT) \
	$(CIL_FILE_VENDOR) $(CIL_FILE_PRODUCT)

	$(RMDIR) $(IMG.OUT)*
	$(RM) $(IMG.IN)*.raw

	@echo -e "\033$(C.EMPH)$(MOD) done!\033[0m"
endef

define DESC
* This modification extracts a sparse IMG
* into the specified directory
endef
