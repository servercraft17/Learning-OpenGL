ifndef BUILDMODE
	BUILDMODE=DEBUG
endif

include buildsys/cfg.mk
include buildsys/directory-vars.mk
include buildsys/common.mk

SRC:= $(call rwildcard,$(src_dir),$(addprefix *,$(src_file_exts)))
OBJ:= $(call rsubsuffix,$(src_file_exts),.o,$(addprefix $(build_dir)/,$(notdir $(SRC))))

dep_list :=
clean_list := 
help_text_list :=

all: ./$(bin_dir)/$(exec_name)
	
# Include deps
include buildsys/assimp-dep.mk
include buildsys/zlib-dep.mk
include buildsys/glew-dep.mk
include buildsys/sdl-dep.mk
include buildsys/boost-dep.mk
include buildsys/sdl_ttf-dep.mk
include buildsys/opengl-dep.mk
# we dont even use the compiled shaders atm nor do I want to make that mess work on linux rn. -server, 2/15/25, 9:24 AM
#include buildsys/compile-shaders.mk
include buildsys/shader-gen-dep.mk

linker_flags += -static-libgcc

ifeq ($(BUILDMODE),DEBUG)
	CFLAGS += -g -ggdb
	linker_flags += -g -ggdb
endif
ifeq ($(BUILDMODE),RELEASE)

endif
ifneq ($(OS),Windows_NT)
	linker_flags += -Wl,-rpath='$$ORIGIN'
endif


./$(bin_dir)/$(exec_name): ./$(bin_dir) ./$(build_dir) $(dep_list) $(OBJ) 
	$(CXXC) $(OBJ) -o $@ $(linker_flags) $(CFLAGS)

./$(build_dir)/%.o: ./src/%.cpp
	@$(call mkdir,$(build_dir))
	$(CXXC) -c $< -o $@ $(inc) $(CFLAGS)

./$(build_dir):
	@$(call mkdir,$(build_dir))

./$(bin_dir):
	@$(call mkdir,$(bin_dir))

.PHONY: clean
clean:
	@$(call rmrf,$(build_dir))
	@$(call rmrf,$(bin_dir))

.PHONY: cleanext
cleanext: $(clean_list)

.PHONY: cleanall
cleanall: clean $(clean_list)

.PHONY: run
run: ./$(bin_dir)/$(exec_name)
	$<

# run(l)og: anything that is logged to console will be instead put into a log.txt file.
.PHONY: runl
runl: ./$(bin_dir)/$(exec_name)
	$<>log.txt

# run(d)ebug: starts debugging shotstop with gdb, you have to type "run" after using this command to run it.
.PHONY: rund
rund: ./$(bin_dir)/$(exec_name)
	gdb $<

.PHONY: help	
help:
	@echo BUILDMODE {var}:
	@echo      	if set to DEBUG ShotStop will be compiled with debug information and in debug mode.
	@echo      	if set to RELEASE ShotStop will be compiled in release mode and will contain no debug information.
	@echo ' ': compiles ShotStop {just like running 'make' in ShotStop\'s base directory}.
	@echo run: compiles and runs ShotStop.
	@echo runl: compiles and runs ShotStop and creates a logfile containing its output.
	@echo rund: compiles and runs ShotStop with gdb for debugging
	@echo clean: cleans ShotStop\'s buildfiles.
	@echo cleanext: cleans all of ShotStop\'s dependencies.
	@echo cleanall: cleans ShotStop\'s buildfiles and dependencies.
	@echo help: shows this message.
	@$(help_print_newline)
	@$(help_text_list)
	@$(help_print_newline)
	@echo NOTE: ShotStop doesn\'t need to be configured, all the configuration is either automatic or done through shell variables or through the 'cfg.mk' files
	@echo  	that are found in the 'buildsys' directory and the subdirectory for your OS {buildsys/{your_os}/}.
	@echo NOTE: All dependencies are handled automatically, so there is no need to download or build them yourself because they are automatically downloaded and
	@echo  	built for you.


# some linux function for making a graph of the memory usage of a program: pmap -x [pid] | tail -n1 | awk '{print $4}'