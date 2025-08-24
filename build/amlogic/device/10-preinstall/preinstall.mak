# DISABLED = yes

HELP = Automatic installation of pre-installed applications on first boot

# We apply the mod only after the mod init.d
DEPS += $(STAMP.mod-init.d)

define INSTALL
	mkdir -p $(VENDOR)preinstall/settings
	cp -a $(DIR)/00-preinstall $(VENDOR)etc/init.d
	cat $(DIR)contexts >> $(SELINUX)vendor_file_contexts
endef
