# DISABLED = yes

HELP = extract aml_upgrade_package only

DEPS += $(IMG.IN).stamp.unpack

define INSTALL
	@echo "extracted!"
endef
