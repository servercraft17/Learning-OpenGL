shader_gen_dir = buildsys

ifeq ($(OS),Windows_NT)
shadergen_exe_name = shader-gen.exe
else
shadergen_exe_name = shader-gen
endif

$(build_dir_path)/$(shadergen_exe_name):
	$(CXXC) -c $(shader_gen_dir)/shader-gen.cpp -o $(build_dir_path)/shader-gen.o
	$(CXXC) $(build_dir_path)/shader-gen.o -o $(build_dir_path)/$(shadergen_exe_name)

$(build_dir_path)/shaders.h: $(build_dir_path)/$(shadergen_exe_name)
	$(call fixslash,$(build_dir_path)/$(shadergen_exe_name))

.PHONY: clean_shader_gen
clean_shader_gen:
	$(call delete,$(build_dir_path)/shaders.h)
	
shader_gen_dep = $(build_dir_path)/shaders.h
shader_gen_clean = clean_shader_gen
shader_gen_include = -I $(build_dir)
dep_list += $(shader_gen_dep)
clean_list += $(shader_gen_clean)
inc += $(shader_gen_include)