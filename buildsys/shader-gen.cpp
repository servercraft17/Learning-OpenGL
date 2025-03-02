#include <filesystem>
#include <fstream>
#include <string>

#include <iostream>

std::string replace(char a, const char* b, std::string source) {
    std::string output="";
    for (int i=0; i<source.length(); i++) { 
        if (source[i] == a) {
            output += b;
            continue;
        }
        output += source[i];
    }
    return output;
}

int main() {
    std::string output_file = "./build/shaders.h";
    std::string shader_dir = "./src/shaders";
    
    std::ofstream generated(output_file);

    std::string gen_content = "#ifndef SS_SHADERS_H\n#define SS_SHADERS_H\nnamespace SS_Shaders {\n";

    for (const auto & entry : std::filesystem::directory_iterator(shader_dir)) {
        if (entry.path().extension() != ".glsl") continue;
        if (entry.path().filename().replace_extension().extension() == ".vert") 
            gen_content.append("\nconst char * vertex_" + replace('-', "_",entry.path().filename().replace_extension().replace_extension().string())+" = ");
        else if (entry.path().filename().replace_extension().extension() == ".frag")
            gen_content.append("\nconst char * fragment_" + replace('-', "_",entry.path().filename().replace_extension().replace_extension().string())+" = ");
        else
            gen_content.append("\nconst char * unknown_" + replace('-', "_",entry.path().filename().replace_extension().replace_extension().string())+" = ");

        std::ifstream current_shader(entry.path());
        std::stringstream buffer;
        buffer << current_shader.rdbuf();
        gen_content.append("\"" + replace('\n', "\\n", buffer.str()) + "\";\n");
        current_shader.close();
    }
    gen_content.append("\n}\n#endif");
    generated << gen_content;
    generated.close();

}