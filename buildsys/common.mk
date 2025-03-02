rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
rdwildcard=$(sort $(dir $(call rwildcard,$1,$2)))

#rsubsuffix: $(call rsubsuffix,.cpp .c,.o,names..)
rsubsuffix=$(sort $(filter-out $(addprefix %,$1),$(foreach s,$1,$(patsubst $(addprefix %,$s),$(addprefix %,$2),$3))))

fwdslash=$(subst \,/,$1)
bckslash=$(subst /,\,$1)


ifeq ($(OS),Windows_NT)
	include buildsys/windows/common.mk
else
	include buildsys/linux/common.mk
endif