# DISABLED = yes

HELP = decompile single or multi dtb

DEPS += $(STAMP.unpack)

define INSTALL
	cd $(BCT.DIR) && ./extract-$(MOD)
endef
