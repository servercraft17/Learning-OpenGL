glew_dir = $(ext_dir_path)/glew

ifeq ($(OS),Windows_NT)
	include buildsys/windows/glew-dep.mk
else 
	include buildsys/linux/glew-dep.mk
endif

dep_list += $(glew_dep)
clean_list += $(glew_clean)
linker_flags += $(glew_flags)
inc += $(glew_include)