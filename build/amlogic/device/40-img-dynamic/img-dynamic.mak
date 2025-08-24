# DISABLED = yes

HELP = create $(MOD) $(IMG.BASE) Android 14/15

# We apply the mod only after the mod-super
DEPS += $(STAMP.mod-super)

define INSTALL
	@$(RM) $(IMG.IN)*.$(LOCAL_SUFFIX)
	@$(RM) $(IMG.IN)$(SUPER_RAW)
	@$(COPY) $(BCT.OUT)/$(SUPER_SPARSE) $(IMG.IN)$(SUPER) && sync
	@$(RM) $(BCT.OUT)/*

	$(TOOLS.DIR)aml_image_v2_packer -r $(IMG.IN)/image.cfg $(IMG.IN) $(BCT.OUT)/$(IMG.BASE)
	@echo -e "\n\033[32mdone!\033[0m"
endef
