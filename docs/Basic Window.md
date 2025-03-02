# Game State
I will be using global static variables to store game state,  the definitions of all of them are bellow:
```C++
// Vars
static SDL_Window* window;
static bool should_quit = false;
```

# 1. Initialization
First we have to initialize SDL and [[GLEW]].

## Basic [[SDL]] Setup
We Initialize [[SDL]] and a window as normal in [[SDL]], but the window has to have the OpenGL flag.
```C++
if (!SDL_Init(SDL_INIT_VIDEO)) {

SDL_Log("SDL Failed to initialize: %s", SDL_GetError());

return 1;

}
// Formatting like this only so it doesn't look ass in obsidian.
// its formatted correctly in the main.cpp source file.
window = SDL_CreateWindow(
	"Learning OpenGL", 
	800, 600, 
	SDL_WINDOW_OPENGL
);

if (!window) {
	SDL_Log("SDL Failed to create a window: %s", SDL_GetError());
	return 1;
}
```

No need to create a [[SDL]] renderer since we are rendering with OpenGL and in 3D.

## Setting up OpenGL
We have to tell [[SDL]] what version of OpenGL we're using, in this case we're using ***`3.1-Core`**.
```C++
SDL_GL_SetAttribute( SDL_GL_CONTEXT_MAJOR_VERSION, 3 );
SDL_GL_SetAttribute( SDL_GL_CONTEXT_MINOR_VERSION, 1 );
SDL_GL_SetAttribute( SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
```

Now that [[SDL]] knows what version of OpenGL we are using we can now create an OpenGL Context. After we create the context we have to make it the current context.
```C++
SDL_GLContext glContext = SDL_GL_CreateContext(window);

if(!glContext) {
	SDL_Log("SDL Failed to create an OpenGL context: %s", SDL_GetError());
	return 1;
}

if (!SDL_GL_MakeCurrent(window, glContext)) {
	SDL_Log("ERROR: Failed to set the current OpenGL context: %s",
		 SDL_GetError());
	return 1;
}
```

Once that's done, we can initialize [[GLEW]]. We want to set a variable that is define in **`glew.h`** called **`glewExperimental`** to **`GL_TRUE`** before initializing [[GLEW]] so that we can access all the OpenGL functions we need.
Then we can call **`glewInit();`** to Initialize [[GLEW]].
```C++
glewExperimental = GL_TRUE;
GLenum glewError = glewInit();
if (glewError != GLEW_OK) {
	SDL_Log("ERROR: Failed to initialize GLEW. %s",
		glewGetErrorString(glewError));
	return 1;
}
```

# 2. Game Loop

It's the same as any other game loop.
I'm going to take the liberty of splitting it into 3 functions for cleanliness and readability.
```C++
// For handling events and keyboard input.
void HandleEvent(SDL_Event& event);
// For updating game state
void Update();
// For rendering the image.
void Render();
```

We will not be tracking fps or limiting it since that is not what we're here for.
This is what our game loop will look like:
```c++
while (!should_quit) {
	SDL_Event event;
	while (SDL_PollEvent(&event)) HandleEvent(event);
	Update();
	Render();
}
```

And this is what the **`HandleEvent`** and **`Render`** functions will look like for now:
```C++
void HandleEvent(SDL_Event& event) {
	if (
		event.type == SDL_EVENT_QUIT || 
		(event.type == SDL_EVENT_KEY_DOWN 
		&& event.key.key == SDLK_ESCAPE) 
	) {
		SDL_Log("Exiting...");
		should_quit=true;
		return;
	}
}

void Render() {
	glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);

	// Swaps the frame buffer, essentially like SDL_RenderPresent() but for OpenGL
	SDL_GL_SwapWindow(window);
}
```

We don't have any game state to update yet so the **`Update`** function will just be empty for now.

# 3. Cleanup
After we exit the [Game Loop](Basic Window#2. Game Loop) we need to clean up after our selves. This will become **MUCH** more involved later on when we start to create buffers and what not. So for right now all we have to do is clean up [[SDL]]. We haven't created anything OpenGL-wise to clean up yet and [[GLEW]] doesn't need to be cleaned up.

This is what our cleanup looks like right now:
```C++
// Uninitialize the OpenGL Context.
SDL_GL_DestroyContext(glContext);
// Destroy the window.
SDL_DestroyWindow(window);
// Clean up SDL.
SDL_Quit();
```
# Compiling
Just make sure you link with OpenGL with the `-lOpenGL32` flag on Windows or `-lGL -lGLU` on Linux and when linking [[GLEW]] to your program, make sure you also link with the static library as well, it will be called `glew32.lib` on Windows and `libGLEW.a` on Linux and make sure its the right static library, depending on how you compile [[GLEW]] there may be two static libraries, one for static linking, and a second for dynamically linking with it's shared library, usually one for static linking will have a lowercase `s` at the end before the file extension.