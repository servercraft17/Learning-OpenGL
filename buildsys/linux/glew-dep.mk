glew_shared_name = libGLEW.so.2.2.0
glew_static_name = libGLEW.a

./$(ext_dir)/glew:
	$(call mkdir,$(glew_dir))

./$(ext_dir)/glew/$(GLEWZIPFile): ./$(ext_dir)/glew
	$(call ifnexe,$(glew_dir)/$(GLEWZIPFile),cd $(glew_dir) && wget $(GLEWURL) && tar -xf $(GLEWZIPFile) $(basename $(GLEWZIPFile))/ -C . --strip-components=1,cd $(glew_dir) && tar -xf $(GLEWZIPFile) $(basename $(GLEWZIPFile))/ -C . --strip-components=1)

$(bin_dir_path)/$(glew_shared_name): ./$(ext_dir)/glew/$(GLEWZIPFile)
	cd $(glew_dir) && $(MAKE)
	$(call copy,$(glew_dir)/lib/$(glew_shared_name),$(bin_dir_path))

$(build_dir_path)/$(glew_static_name): $(bin_dir_path)/$(glew_shared_name)
	$(call copy,$(glew_dir)/lib/$(glew_static_name),$(build_dir_path))

.PHONY: clean_glew
clean_glew:
	cd $(glew_dir) && $(MAKE) clean

glew_dep = $(build_dir_path)/$(glew_static_name) $(bin_dir_path)/$(glew_shared_name)
glew_clean = clean_glew
glew_include = -I $(ext_dir)/glew/include
glew_flags = $(build_dir)/$(glew_static_name) -l:$(bin_dir)/libGLEW.so.2.2.0