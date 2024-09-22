extern "C" void main();

void print_char(char c, int x, int y);
void print_string(const char* str, int x, int y);
void clear_screen();

extern "C" void main() {
    clear_screen();
    print_string("Hello from the Kernel!", 0, 0);
    print_string("Welcome to 32-bit protected mode.", 0, 2);

    // Loop forever
    while (1);
}

void print_char(char c, int x, int y) {
    // VGA video memory starts at address 0xB8000
    volatile char* video_memory = (volatile char*) 0xB8000;
    int index = 2 * (y * 80 + x); // Each character takes 2 bytes: 1 for ASCII and 1 for attribute
    video_memory[index] = c;
    video_memory[index + 1] = 0x07; 
}

void print_string(const char* str, int x, int y) {
    int i = 0;
    while (str[i] != '\0') {
        print_char(str[i], x + i, y);
        i++;
    }
}

void clear_screen() {
    volatile char* video_memory = (volatile char*) 0xB8000;
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        video_memory[i] = ' '; 
        video_memory[i + 1] = 0x07;
    }
}
