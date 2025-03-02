src_file_exts = .cpp .c

build_dir = build
bin_dir = bin
src_dir = src
ext_dir = external

ifeq ($(OS),Windows_NT) 
	include buildsys/windows/cfg.mk
else
	include buildsys/linux/cfg.mk
endif