SDL_DEP_MK_INCLUDED = 
sdl_dir = $(ext_dir_path)/SDL

ifeq ($(OS),Windows_NT) 
	sdl_binary_name = SDL3.dll
else
	sdl_binary_name = libSDL3.so.0
endif

./$(ext_dir)/SDL:
	git clone https://github.com/libsdl-org/SDL.git $@

./$(bin_dir)/$(sdl_binary_name): ./$(ext_dir)/SDL ./$(bin_dir)
	@$(call ifnex,$(sdl_dir)/build/$(sdl_binary_name),$(call mkdir,$(sdl_dir)/build) && cd $(call fixslash,$(sdl_dir)/build) && cmake .. -DCMAKE_BUILD_TYPE=Release -G $(cmake_makefile_generator) -DSDL_TESTS=OFF -DCMAKE_MAKE_PROGRAM=$(MAKE) -DCMAKE_C_COMPILER=$(CC) && cmake --build . --config Release)
	@$(call copy,$(sdl_dir)/build/$(sdl_binary_name),$(bin_dir_path)/$(sdl_binary_name))

.PHONY: clean_SDL
clean_SDL:
	cd $(sdl_dir)/build && $(MAKE) -f Makefile clean

sdl_dep = ./$(bin_dir)/$(sdl_binary_name)
sdl_clean = clean_SDL
sdl_include = -I $(ext_dir)/SDL/include
sdl_flags = -l:$(bin_dir)/$(sdl_binary_name)
dep_list += $(sdl_dep)
clean_list += $(sdl_clean)
linker_flags += $(sdl_flags)
inc += $(sdl_include)