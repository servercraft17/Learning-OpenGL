#include <iostream>

#include <SDL3/SDL.h>

#include <GL/glew.h>

#include <SDL3/SDL_opengl.h>
#include <GL/glut.h>


#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600


void HandleEvent(SDL_Event& event);
void Update();
void Render();

// Vars
static SDL_Window* window;
static bool should_quit = false;


int main() {
// 1. Initialization
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL Failed to initialize: %s", SDL_GetError());
        return 1;
    }

    window = SDL_CreateWindow("Learning OpenGL: Basic Triangle", WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_OPENGL);
    if (!window) {
        SDL_Log("SDL Failed to create a window: %s", SDL_GetError());
        return 1;
    }

    SDL_GL_SetAttribute( SDL_GL_CONTEXT_MAJOR_VERSION, 3 );
    SDL_GL_SetAttribute( SDL_GL_CONTEXT_MINOR_VERSION, 1 );
    SDL_GL_SetAttribute( SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

    SDL_GLContext glContext = SDL_GL_CreateContext(window);
    if(!glContext) {
        SDL_Log("SDL Failed to create an OpenGL context: %s", SDL_GetError());
        return 1;
    }

    if (!SDL_GL_MakeCurrent(window, glContext)) {
        SDL_Log("ERROR: Failed to set the current OpenGL context: %s", SDL_GetError());
        return 1;
    }

    glewExperimental = GL_TRUE;
    GLenum glewError = glewInit();
    if (glewError != GLEW_OK) {
        SDL_Log("ERROR: Failed to initialize GLEW. %s", glewGetErrorString(glewError));
        return 1;
    }

    // Tell OpenGL the size of our window.
    glViewport(0,0,WINDOW_WIDTH, WINDOW_HEIGHT);

    // Set Vsync
    if (!SDL_GL_SetSwapInterval(0)) 
        SDL_Log("WARNING: Failed to set vsync. %s", SDL_GetError());

// 2. Game Loop
    while (!should_quit) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) HandleEvent(event);
        Update();
        Render();
    }

// 3. Cleanup
    SDL_GL_DestroyContext(glContext);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void HandleEvent(SDL_Event &event) {
    if (event.type == SDL_EVENT_QUIT || (event.type == SDL_EVENT_KEY_DOWN && event.key.key == SDLK_ESCAPE)) {
        SDL_Log("Exiting...");
        should_quit=true;
        return;
    }
}

void Update() {

}

void Render() {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Swaps the frame buffer, essentially like SDL_RenderPresent() but for OpenGL
    SDL_GL_SwapWindow(window);
}
