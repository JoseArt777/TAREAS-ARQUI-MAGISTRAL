#include <unistd.h>

int main() {
    
    const char string1[] = "Hello, World!\n";
    char string2[15];
    
    const char *src = string1;
    char *dst = string2;
    
    while (*src != '\0') {
        *dst = *src;
        src++;
        dst++;
    }
    *dst = '\0';
    write(1, string2, 15);
    return 0;
}
