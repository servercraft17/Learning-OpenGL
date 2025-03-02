fixslash = $(bckslash)

cmake_makefile_generator = "MinGW Makefiles"
unzip = tar -xf

help_print_newline = powershell Write-Output `n

define mkdir
	if not exist $(call fixslash,$1) (mkdir $(call fixslash,$1))
endef
define rmdir
	if exist $(call fixslash,$1) (rmdir $(call fixslash,$1) $2)
endef
define copy
	if exist $(call fixslash,$1) (copy $(call fixslash,$1) $(call fixslash,$2) /y)
endef
define delete
	if exist $(call fixslash $1) (del /Q $2 $(call fixslash,$1))
endef
define ifnex
	if not exist $(call fixslash,$1) ($2)
endef
define ifnexe
	if not exist $(call fixslash,$1) ($2) else ($3)
endef
define ifex
	if not exist $(call fixslash,$1) ($2)
endef
define ifexe
	if not exist $(call fixslash,$1) ($2) else ($3)
endef
define ifwinnt
	if "%OS%" == "Windows_NT" ($1) else ($2)
endef
define rmrf
	del /S /Q $(call fixslash,$1)
endef
