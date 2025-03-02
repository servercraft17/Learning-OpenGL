zlib_dir = $(ext_dir_path)/zlib

./$(build_dir)/libz.a: ./$(ext_dir)/zlib
	@$(call ifnex,./$(ext_dir)/zlib/libz.a,cd $(call fixslash,$(ext_dir)/zlib) && bash configure --static && make)
	@$(call copy,./$(ext_dir)/zlib/libz.a,./$(build_dir)/libz.a)
./$(ext_dir)/zlib:
	git clone --branch master https://github.com/madler/zlib.git $@
	cd $(zlib_dir) && dos2unix *

.PHONY: clean_zlib
clean_zlib:	
	cd $(zlib_dir) && $(MAKE) -f Makefile distclean

zlib_dep = ./$(build_dir)/libz.a
zlib_clean = clean_zlib
zlib_include = -I $(ext_dir)/zlib
zlib_flags = $(call fixslash,$(build_dir)/libz.a)
dep_list += $(zlib_dep)
clean_list += $(zlib_clean)
linker_flags += $(zlib_flags)
inc += $(zlib_include)