# DISABLED = yes

HELP = create $(IMG.BASE) Android-14/15, old format package "system_as_root"

define INSTALL
	$(TOOLS.DIR)aml_image_v2_packer -r $(IMG.IN)/image.cfg $(IMG.IN) $(BCT.OUT)/$(IMG.BASE)
	@echo -e "\n\033[32mdone!\033[0m"
endef
