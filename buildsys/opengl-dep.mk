ifeq ($(OS),Windows_NT)
	linker_flags += -lOpenGL32
else 
	linker_flags += -lGL -lGLU
endif