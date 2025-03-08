#version 330 core
// we have to specify the version of OpenGL we're using at the top of our file.

layout (location = 0) in vec3 aPos;

void main()
{
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}