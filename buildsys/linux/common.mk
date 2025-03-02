fixslash = $(fwdslash)

cmake_makefile_generator = "Unix Makefiles"
unzip = unzip

help_print_newline = echo

define mkdir
	if [ ! -e "$(call fixslash,$1)" ]; then mkdir $(call fixslash,$1); fi
endef
define rmdir
	if [ -e "$(call fixslash,$1)" ]; then rmdir $2 $(call fixslash,$1); fi
endef
define copy
	if [ -e "$(call fixslash,$1)" ]; then cp $3 $1 $2; fi
endef
define delete
	if [ -e "$(call fixslash,$1)" ]; then rm $2 $(call fixslash,$1); fi
endef
define ifnex
	if [ ! -e "$(call fixslash,$1)" ]; then $2; fi
endef
define ifnexe
	if [ ! -e "$(call fixslash,$1)" ]; then $2; else $3; fi
endef
define ifex
	if [ -e "$(call fixslash,$1)" ]; then $2; fi
endef
define ifexe
	if [ -e "$(call fixslash,$1)" ]; then $2; else $3; fi
endef
define ifwinnt
	if [ "$(OS)" = "Windows_NT"]; then $1; else $2; fi
endef
define rmrf
	rm -rf $(call fixslash,$1)
endef