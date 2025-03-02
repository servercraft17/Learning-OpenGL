glew_shared_name = glew32.dll
glew_static_name = glew32.lib

$(bin_dir_path)/$(glew_shared_name):
	$(call mkdir,$(glew_dir))
	$(call ifnexe,$(glew_dir)/$(GLEWZIPFile),cd $(glew_dir) && wget $(GLEWURL) && $(unzip) $(GLEWZIPFile) glew-2.2.0/include glew-2.2.0/bin/Release/x64 glew-2.2.0/lib/Release/x64,cd $(glew_dir) && $(unzip) $(GLEWZIPFile) glew-2.2.0/include glew-2.2.0/bin/Release/x64 glew-2.2.0/lib/Release/x64)
	$(call copy,$(glew_dir)/glew-2.2.0/bin/Release/x64/$(glew_shared_name),$(bin_dir_path))

$(build_dir_path)/$(glew_static_name):
	$(call mkdir,$(glew_dir))
	$(call ifnexe,$(glew_dir)/$(GLEWZIPFile),cd $(glew_dir) && wget $(GLEWURL) && $(unzip) $(GLEWZIPFile) glew-2.2.0/include glew-2.2.0/bin/Release/x64 glew-2.2.0/lib/Release/x64,cd $(glew_dir) && $(unzip) $(GLEWZIPFile) glew-2.2.0/include glew-2.2.0/bin/Release/x64 glew-2.2.0/lib/Release/x64)
	$(call copy,$(glew_dir)/glew-2.2.0/lib/Release/x64/$(glew_static_name),$(build_dir_path))

.PHONY: clean_glew
clean_glew:
	cd $(glew_dir) && $(call rmrf,*.exe *.lib *.dll *.so *.a)

glew_dep = $(build_dir_path)/$(glew_static_name) $(bin_dir_path)/$(glew_shared_name)
glew_clean = clean_glew
glew_include = -I $(ext_dir)/glew/glew-2.2.0/include
glew_flags = $(build_dir)/$(glew_static_name) -l$(bin_dir)/glew32