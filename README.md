# OpenGL Notes
This is a repository containing all my notes and what not I wrote and used for learning OpenGL (with C++ + SDL)
You can find the actual notes in the `docs` directory.

# Building
See the sections below for windows and linux.
the only difference between running `make` and `make run` is that `make run` runs the program after it's done building it.

## Windows
Just run `make` or `make run` and everything will be built for you, all dependencies and everything.

## Linux
Run `./configure` then run `make` or `make run` and everything will be build for you, all dependencies and everything.
In theory you shouldn't have to run `./configure` but I've had issues with it on linux.

# Adding more example programs
To add more example programs just create a new file in the `src` directory with the file extension `.main.cpp`.
Anything that is used by multiple example should be put into the common directory and shouldn't have the `.main.cpp` extension.