ifndef mkfile_path
    mkfile_path := $(abspath $(firstword $(MAKEFILE_LIST)))
endif

current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
base_dir := $(dir $(mkfile_path))
ext_dir_path := $(base_dir)$(ext_dir)
bin_dir_path := $(base_dir)$(bin_dir)
build_dir_path := $(base_dir)$(build_dir)
