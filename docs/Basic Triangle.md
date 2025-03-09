We can start off by copy-pasting the code from [[Basic Window]] into a new file for here, because everything is the same, we're just adding stuff.

OpenGL passes the data you send to the GPU through a bunch of shaders which process the data. There are 6 different shaders that OpenGL uses but only 2 of them are important right now. The [[Vertex Shader]] and the [[Fragment Shader]].

### Vertex Shader
The [[Vertex Shader]] processes all of the ***vertices*** 
### Fragment Shader
The [[Fragment Shader]] processes the color of each pixel.

# Define Vertex Data
We first need some vertices to draw, in this case in the shape of a triangle. We'll just put this under **Initialization** from before. This will be the code:
```C++
float vertices[] = {
    -0.5f, -0.5f, 0.0f,
     0.5f, -0.5f, 0.0f,
     0.0f,  0.5f, 0.0f
};  
```
Note that these coordinates are [[Normalized Device Coordinates]]. **Any vertex with a component less than -1 or greater than 1 will be discarded/clipped.**

# GPU Memory
Now we that we have defined some vertex data, we want to send it to the GPU so it can be processed by the [[Vertex Shader]], the first step of the graphics pipeline. To do this we allocate some memory on the GPU where we store our vertex data, tell OpenGL how it should interpret the memory and how the data should be sent to the graphics card. 

We manage GPU memory with [Vertex Buffer Objects](VBO) ([[VBO]]), which can store a large number of vertices in GPU memory.

# Setting up Shaders
First we should load our vertex data into [[VRAM]] so later on we can actually use it. So first we need to create a [[VBO]], that we can do using `glGenBuffers()`, which takes in the number of buffers we want to create and a pointer to an `unsigned int`. `glGenBuffers()` sets the pointer to an ID that we use to reference the buffer.
```C++
unsigned VBO;
glGenBuffers(1, &VBO);
```

Now we have to bind our [[VBO]] so we can use it. Binding a buffer is how we reference buffers when we want to actually access them, we don't pass the [[VBO]] to each function, instead we bind it to a **target**, and pass the target that we bound our [[VBO]] to, in this case we bound our [[VBO]] to the `GL_ARRAY_BUFFER` target. 

`GL_ARRAY_BUFFER` is the target meant for [Vertex Buffer Objects](VBO).

We can bind multiple buffers at the same time as long as they are all bound to different targets. But make sure that the target you're binding you're buffer to is meant for that type of buffer, because you can't just bind any target to any buffer, every target is meant for a different type of buffer. The target a buffer object is bound to tells OpenGL how to read that data. Binding a [[VBO]] to a target meant for handling texture data is not a good idea because OpenGL will try to read your vertex data as if it was texture data.
```C++
glBindBuffer(GL_ARRAY_BUFFER, VBO);
```

Time to put our vertex data into our [[VBO]]. For this we use `glBufferData()`. The first 3 parameters of `glBufferData()` are pretty straight forward. The *4th* parameter just tells OpenGL how much the data in this [[VBO]] is used and changed, you have *3* options to choose from.
- `GL_STREAM_DRAW`: *Data never changes and is not used often.* -> *OpenGL will stream the data from [[DRAM]] to the **GPU**.*
- `GL_STATIC_DRAW`: *Data never changes and is used often.* -> *OpenGL will store the data in [[VRAM]] in places that ensure faster reads.*
- `GL_DYNAMIC_DRAW`: *Data changes frequently and is used often*. -> *OpenGL will store the data in [[VRAM]] in places that ensure faster writes.*
In this case, `GL_STATIC_DRAW` is the best choice since we're going to be using it every frame and never going to change it.
```C++
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
```

Now we want to actually process our vertex data that we've loaded. That's where shaders come in. Shaders are used to process data on the GPU in OpenGL, and we tell the GPU how to process that data using ***GLSL*** *(Open{GL} {S}hading {L}anguage)*.  At the top of every GLSL shader you have to specify the version of OpenGL that shader is meant for, in this case OpenGL 3.3 core. We have to take in the vertex data so we can process it in the vertex shader, which is does using `layout (location = #) in <type> name;`, location is just **{I HAVE NO FUCKING IDEA}** and the rest is kinda self explanatory.  Each shader needs a main function, which is declared the same way as in C.
```c
#version 330 core

layout (location = 0) in vec3 aPos;
void main()
{
	// I have no idea why we set gl_Position, idk where we get that from.
	gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
```

Now time to actually load the shader. OpenGL doesn't actually load shaders from files, you just provide OpenGL with strings that contain GLSL code. But I don't like doing that so as a part of my build system I have it take the contents of all the GLSL files and dump it all into a header file as constants.  Just like with the [[VBO]], `glCreateShader()` will give us an ID to reference the shader by, this time as a return value. `glCreateShader()`'s only parameter is type of shader, while there is 6 types of shaders, we're only going to be using two, because the rest OpenGL already has for us or are not a requirement. The two types of shaders that we'll be making are the vertex shader and the fragment shader, however, we'll deal with the fragment shader later.
```C++
unsigned vertexShader = glCreateShader(GL_VERTEX_SHADER);
```

We have to give OpenGL the source code to our shader for it to compile, which is done with `glShaderSource()`. The second parameter is the number of strings your passing to it, which is just `1` in this case, the third parameter is the string containing the shader source code, and the 4th is parameter is can just be `NULL`. After we give OpenGL the source code to our shaders, we can compile using `glCompileShader()`.  Then we can check if the compilation succeeded by using `glGetShaderiv()`, and if it did fail, we get the error message with `glGetShaderInfoLog()`.
```C++
glShaderSource(vertexShader, 1, &Shaders::vertex_basic_triangle, NULL);
glCompileShader(vertexShader);

int compilation_success;
char compilation_log[1024];
glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &compilation_success);
if (!compilation_success) {
	// Second param is just the size of your char array.
	// And third param you can just leave NULL.
	glGetShaderInfoLog(vertexShader, 1024, NULL, compilation_log);
	SDL_Log("ERROR: Failed to compile vertex shader. %s", compilation_log);
}
```
## Fragment Shader
The *fragment shader* tells the GPU how to color each pixels, by creating **fragments**, which are just the data required to draw each pixel to the screen. The fragment shader outputs the color of the fragment. Our fragment shader will look like this.
```c
#version 330 core
// Specifies that this will be an output of the shader.
out vec4 FragColor;

void main()
{
	// Set every pixel to the same color.
	FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
```

And now we load our fragment shader just like we did the vertex shader.
```C++
unsigned fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
glShaderSource(fragmentShader, 1, &Shaders::fragment_basic_triangle, NULL);
glCompileShader(fragmentShader);

int compilation_success;
char compilation_log[1024];
glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &compilation_success);
if (!compilation_success) {
	// Second param is just the size of your char array.
	// And third param you can just leave NULL.
	glGetShaderInfoLog(fragmentShader, 1024, NULL, compilation_log);
	SDL_Log("ERROR: Failed to compile fragment shader. %s", compilation_log);
}
```

## Shader Programs
Now that we have loaded our shaders, we can't use them.. At least not until we link them to a shader program. A shader program is essentially the '*executable*' while the compiled shaders are like the '*objects*', similar with compiling a C program. To use the shaders we need the executable and for that we need to link the objects. Creating and linking the program is easy though. To create the program we use `glCreateProgram()` that returns an ID that we use to reference it. To link it we first attach the shaders to it using `glAttachShader()` then we link it using `glLinkProgram()`.
```C++
unsigned sp = glCreateProgram();
glAttachShader(sp, vertexShader);
glAttachShader(sp, fragmentShader);
glLinkProgram(sp);
```

But we don't want to use the shader program if it failed to link, we can check that the same way we did the shader compilation but this time using the functions `glGetProgramiv()` and `glGetProgramInfoLog()`.
```C++
int link_success;
char link_log[1024];
glGetProgramiv(sp, GL_LINK_STATUS, &link_success);
if (!link_success) {
	glGetProgramInfoLog(sp, 1024, NULL, link_log);
	SDL_Log("ERROR: Failed to link shader program. %s", link_log);
}
```

What we're left with is a program object that we can activate using `glUseProgram()`!
```C++
glUseProgarm(sp);
```

We also don't need the shader objects anymore so we can delete them.
```C++
glDeleteShader(vertexShader);
glDeleteShader(fragmentShader);
```

Now we've given the GPU our vertex data *(which is in [[VRAM]])* and we've told the GPU how it should process that data. *(using the vertex and fragment shaders)* So we're almost there, but the GPU still doesn't know how it should interpret the vertex data nor how it should said data to the shader's attributes. We will tell OpenGL how to do that.

## Linking Vertex Attributes
The vertex shader allows us to specify any input we want in the form of vertex attributes, in other words, we can just give the vertex shader what ever data we want and it will just take it. This is nice and makes it very flexible, but means that we have to tell it what the data we give it means.

We'll format our vertex data the same way the people at [LearnOpenGL](https://learnopengl.com) did because I couldn't be bothered to make my own image for this.
![vertex data format](https://learnopengl.com/img/getting-started/vertex_attribute_pointer.png "vertex data format")
- The position data is stored as 32-bit (4 byte) floating point values.
- Each position is composed of 3 of those values.
- There is no space (or other values) between each set of 3 values. The values are tightly packed in the array.
- The first value in the data is at the beginning of the buffer.