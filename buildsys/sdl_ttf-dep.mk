ifdef SDL_DEP_MK_INCLUDED
    include buildsys/sdl-dep.mk
	$(eval $(error I have no Idea why this error is here. lol.))
endif
sdl_ttf_dir = $(ext_dir_path)/SDL_ttf

./$(build_dir)/libSDL3_ttf.a: ./$(ext_dir)/SDL_ttf $(sdl_dep)
	$(call ifnex,$(sdl_ttf_dir)/build/libSDL3_ttf.a,$(call mkdir,$(sdl_ttf_dir)/build) && cd $(call fixslash,$(sdl_ttf_dir)/build) && cmake .. -DCMAKE_BUILD_TYPE=Release -G $(cmake_makefile_generator) -DCMAKE_MAKE_PROGRAM=$(MAKE) -DCMAKE_C_COMPILER=$(CC) -DBUILD_SHARED_LIBS=OFF -DSDL3_DIR=$(sdl_dir)/build -DSDLTTF_FREETYPE_VENDORED=ON -DSDLTTF_FREETYPE=ON -DSDLTTF_VENDORED=ON -DSDLTTF_SAMPLES=OFF && cmake --build . --config Release)
	@$(call copy,$(sdl_ttf_dir)/build/libSDL3_ttf.a,$(build_dir_path)/libSDL3_ttf.a) && $(call copy,$(sdl_ttf_dir)/build/external/freetype/libfreetype.a,$(build_dir_path)/libfreetype.a)

./$(ext_dir)/SDL_ttf:
	git clone --recurse-submodules https://github.com/libsdl-org/SDL_ttf.git $@
	$(call rmrf,$(sdl_ttf_dir)/external/SDL)

.PHONY: clean_SDL_ttf
clean_SDL_ttf:
	cd $(sdl_ttf_dir)/build && $(MAKE) -f Makefile clean

sdl_ttf_dep = ./$(build_dir)/libSDL3_ttf.a
sdl_ttf_clean = clean_SDL_ttf
sdl_ttf_include = -I $(ext_dir)/SDL_ttf/include
sdl_ttf_flags = $(call fixslash,$(build_dir)/libSDL3_ttf.a) $(call fixslash,$(build_dir)/libfreetype.a)

dep_list += $(sdl_ttf_dep)
clean_list += $(sdl_ttf_clean)
linker_flags += $(sdl_ttf_flags)
inc += $(sdl_ttf_include)							