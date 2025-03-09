#version 330 core
// Specifies that this will be an output of the shader.
out vec4 FragColor;

void main()
{
	// Set every pixel to the same color.
	FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
