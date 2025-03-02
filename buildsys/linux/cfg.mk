CXXC = g++
CC = gcc

exec_name = ogl_test

inc =\
	-I src\
	-I $(src_dir)/ext\
	-I $(build_dir)

CFLAGS =\
	-std=c++17\
	-fdiagnostics-color=always\
	-m64\

linker_flags = -L.

GLEWURL = https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
GLEWZIPFile = $(notdir $(GLEWURL))

# Shader stuff
DXShaderCompilerURL = https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2407/dxc_2024_07_31.zip
DXShaderCompilerZIPFile = $(notdir $(DXShaderCompilerURL))