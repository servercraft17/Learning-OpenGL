SHSRC := $(wildcard $(src_dir)/shaders/*.hlsl)
SHOBJ := $(subst $(src_dir)/shaders/,./$(bin_dir)/shaders/compiled/SPIRV/,$(patsubst %.hlsl,%.spv,$(SHSRC))) $(subst $(src_dir)/shaders/,./$(bin_dir)/shaders/compiled/MSL/,$(patsubst %.hlsl,%.msl,$(SHSRC))) $(subst $(src_dir)/shaders/,./$(bin_dir)/shaders/compiled/DXIL/,$(patsubst %.hlsl,%.dxil,$(SHSRC)))

./$(ext_dir)/SDL_shadercross:
	git clone https://github.com/libsdl-org/SDL_shadercross.git $@

./$(ext_dir)/SDL_shadercross/build/shadercross.exe: ./$(ext_dir)/SDL_shadercross ./$(ext_dir)/DirectXShaderCompiler/bin/x64/dxil.dll ./$(ext_dir)/SPIRV-Cross/build/libspirv-cross-c-shared.dll ./$(bin_dir)/SDL3.dll
	cmake -S$< -B$</build -G"MinGW Makefiles" -DCMAKE_MAKE_PROGRAM=make -DSDL3_DIR=$(call bckslash,$(sdl_dir))\build -Dspirv_cross_c_shared_DIR=..\SPIRV-Cross\build -DDirectXShaderCompiler_INCLUDE_PATH=$(ext_dir)\DirectXShaderCompiler\inc -DDirectXShaderCompiler_dxcompiler_LIBRARY=$(ext_dir)\DirectXShaderCompiler\lib\x64\dxcompiler.lib -DDirectXShaderCompiler_dxil_BINARY=$(ext_dir)\DirectXShaderCompiler\bin\x64\dxil.dll  
	cd $</build && make

./$(ext_dir)/SPIRV-Cross:
	git clone https://github.com/KhronosGroup/SPIRV-Cross.git $@

./$(ext_dir)/SPIRV-Cross/build/libspirv-cross-c-shared.dll: ./$(ext_dir)/SPIRV-Cross
	cmake -S$< -B$</build -G"MinGW Makefiles" -DCMAKE_MAKE_PROGRAM=make -DSPIRV_CROSS_SHARED=ON
	cd $</build && make

./$(ext_dir)/DirectXShaderCompiler:
	wget $(DXShaderCompilerURL) -P$@
	cd $@ && tar -xf $(DXShaderCompilerZIPFile) bin/x64 inc lib/x64

./$(ext_dir)/DirectXShaderCompiler/bin/x64/dxil.dll: ./$(ext_dir)/DirectXShaderCompiler
	@if not exist $</$(DXShaderCompilerZIPFile) (\
		wget $(DXShaderCompilerURL) \
	)
	@if not exist $@ (cd $< && tar -xf $(DXShaderCompilerZIPFile) bin/x64 inc lib/x64)

./$(bin_dir)/shadercross.exe: ./$(ext_dir)/SDL_shadercross/build/shadercross.exe
	@if not exist $(build_dir) (mkdir $(build_dir))
	@if not exist $(bin_dir) (mkdir $(bin_dir))
	copy /y .\$(ext_dir)\DirectXShaderCompiler\bin\x64\dxil.dll .\$(bin_dir)\dxil.dll
	copy /y .\$(ext_dir)\SPIRV-Cross\build\libspirv-cross-c-shared.dll .\$(bin_dir)\libspirv-cross-c-shared.dll
	copy /y $(subst /,\,$<) $(subst /,\,$@)

cleanshaderlibs:
	taskkill /F /FI "IMAGENAME eq git.exe"
	if exist $(ext_dir)\SPIRV-Cross (rmdir $(ext_dir)\SPIRV-Cross /s /q)
	if exist $(ext_dir)\SDL_shadercross (rmdir $(ext_dir)\SDL_shadercross /s /q)
	if exist $(ext_dir)\DirectXShaderCompiler (rmdir $(ext_dir)\DirectXShaderCompiler /s /q)

.\$(bin_dir)\shaders\compiled\SPIRV:
	md $@

.\$(bin_dir)\shaders\compiled\MSL:
	md $@

.\$(bin_dir)\shaders\compiled\DXIL:
	md $@

./$(bin_dir)/shaders/compiled/SPIRV/%.spv: ./$(src_dir)/shaders/%.hlsl 
	./$(bin_dir)/shadercross.exe "$<" -o "$@"

./$(bin_dir)/shaders/compiled/MSL/%.msl: ./$(src_dir)/shaders/%.hlsl
	./$(bin_dir)/shadercross.exe "$<" -o "$@"

./$(bin_dir)/shaders/compiled/DXIL/%.dxil: ./$(src_dir)/shaders/%.hlsl
	./$(bin_dir)/shadercross.exe "$<" -o "$@"

shader_deps = ./$(bin_dir)/shadercross.exe .\$(bin_dir)\shaders\compiled\SPIRV .\$(bin_dir)\shaders\compiled\MSL .\$(bin_dir)\shaders\compiled\DXIL $(SHOBJ)
shaders_clean = cleanshaderlibs
dep_list += $(shader_deps)
clean_list += $(shaders_clean)