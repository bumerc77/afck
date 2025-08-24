# DISABLED = yes

HELP = add init.d support

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	mkdir -p $(VENDOR)etc/init.d
	cp $(DIR)init.d.rc $(VENDOR)etc/init
	cp $(DIR)run-init.d $(VENDOR)bin
	cat $(DIR)contexts >> $(SELINUX)vendor_file_contexts
endef

define DESC
Добавлена поддержка автозапуска скриптов из подкаталогов init.d.
Автозапуск происходит в момент окончания загрузки, т.е. когда
анимированная заставка начинает меняться на рабочий стол.

    * В первую очередь запускаются скрипты из подкаталога /vendor/etc/init.d/
    * Затем запускаются скрипты из /system/etc/init.d/
    * Результаты работы можно найти в файле /data/local/vendor-init.d.log
      и /data/local/system-init.d.log. Очень полезно туда заглянуть, если
      что-то пошло не так.
endef
