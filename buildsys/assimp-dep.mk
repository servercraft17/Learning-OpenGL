assimp_dir = $(ext_dir_path)/assimp

./$(build_dir)/libassimp.a: ./$(ext_dir)/assimp    
	@$(call ifnex,./$(ext_dir)/assimp/lib/libassimp.a,cd $(call fixslash,$(ext_dir)\assimp) && cmake CMakeLists.txt -D BUILD_SHARED_LIBS=OFF -D CMAKE_C_COMPILER="$(CC)" -D CMAKE_CXX_COMPILER="$(CXXC)" -G $(cmake_makefile_generator) -DCMAKE_MAKE_PROGRAM=$(MAKE) -DASSIMP_BUILD_ZLIB=ON -DASSIMP_WARNINGS_AS_ERRORS=OFF && cmake --build . --config release)
	@$(call copy,./$(ext_dir)/assimp/lib/libassimp.a,./$(build_dir)/libassimp.a)

./$(ext_dir)/assimp:
	git clone https://github.com/assimp/assimp.git $@

.PHONY: clean_assimp
clean_assimp:	
	cd $(assimp_dir) && $(MAKE) -f Makefile clean

assimp_dep = ./$(build_dir)/libassimp.a
assimp_clean = clean_assimp
assimp_include = -I $(ext_dir)/assimp/include
assimp_flags = $(call fixslash,$(build_dir)\libassimp.a) -lstdc++
dep_list += $(assimp_dep)
clean_list += $(assimp_clean)
linker_flags += $(assimp_flags)
inc += $(assimp_include)