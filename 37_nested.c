#include <stdio.h>

int main() {
    char pattern[36];
    char *ptr = pattern;
    char end = '5';

    for (char i = '1'; i <= end; i++) {
        for (char j = '1'; j <= i; j++) {
            *ptr = j;
            ptr++;
            *ptr = ' ';
            ptr++;
        }
        
        *ptr = '\n';
        ptr++;
    }
    
    *ptr = '\0';

    printf("%s", pattern);

    return 0;
}
