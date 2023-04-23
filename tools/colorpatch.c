#include <stdio.h>
#include <stdlib.h>

/* Tool to generate a P3 .ppm image file to view a single color. Creates a 
 * full row x col image of the given RGB value. */

void usage(char *fname)
{
    fprintf(stderr, "Usage: %s row col rval gval bval\n", fname);
    exit(0);
}

void header(int row, int col)
{
    printf("P3\n");
    printf("%d %d\n", row, col);
    printf("%d\n", 255); // color depth, could add as option later
}

int main(int argc, char *argv[])
{
    if (argc < 6) {
        usage(argv[0]);
    } else if (argc > 6) {
        fprintf(stderr, "%d extra arguments provided, ignoring\n", 6 - argc);
    }

    int row = atoi(argv[1]);
    int col = atoi(argv[2]);
    int r = atoi(argv[3]);
    int g = atoi(argv[4]);
    int b = atoi(argv[5]);
    
    header(row, col);
    for (int i = 0; i < row * col; i++) {
        printf("%d %d %d\n", r, g, b);
    }
    return 0;
}
