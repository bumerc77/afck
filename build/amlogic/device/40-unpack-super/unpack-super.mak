# DISABLED = yes

HELP = $(MOD) $(LOCAL_SUFFIX) Android-14/15

DEPS += $(IMG.IN).stamp.unpack

ifneq ($(MESON_DTB), true)
LOCAL_DTB := $(IMG.IN)_aml_dtb.PARTITION
else
LOCAL_DTB := $(IMG.IN)meson1.dtb
endif

ifeq ($(INSPECT_REPACKED_IMG), true)
INSPECT_SCR_STOCK := $(BCT.DIR)test/gen_perms_caps_labels_stock.sh
endif

define INSTALL
	@echo -e "\n\033$(C.YELLOW)Copy dtb:\033[0m"
	$(COPY) $(LOCAL_DTB) $(BCT.DIR)DTB && sync

	@echo -e "\n\033$(C.YELLOW)Fill partition table:\033[0m"
	@cd $(BCT.DIR) && ./$(MOD) $(SUPER) $(PWD)/$(IMG.IN) \
	odm vendor product system system_ext vendor_dlkm super \
	$(PWD)/$(BCT.DIR)part_table

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

	@cat $(DIR)system_contexts >> $(SELINUX)plat_file_contexts
	@cat $(DIR)vendor_contexts >> $(SELINUX)vendor_file_contexts

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
* This modification extracts a super IMG
* into the specified directory
endef
