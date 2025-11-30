# DISABLED = yes

HELP = $(MOD) and dynamic partitions

DEPS += $(STAMP.unpack)

define INSTALL
	@cd $(BCT.DIR) && ./resize-super $(PWD)/$(IMG.IN)$(SUPER_RAW) $(BCT.DIR) .stamp.mod-super
	@echo "replace old dtb..."
	$(RM) $(LOCAL_DTB)
	$(COPY) $(BCT.DIR)DTB $(LOCAL_DTB) && sync
endef
