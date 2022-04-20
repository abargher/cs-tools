#include <stdio.h>
#include <ctype.h>

// This is the source code for the bytes utility stored in ~/CMSC/tools

// display a file one byte at a time
int main(int argc, char *argv[])
{
    int i = 0;
    int c = getc(stdin);
    while (c!=EOF) {
        if (isgraph(c) || c==' ')
            printf("%6d\t%3d\t'%c'\n",i,c,c);
        else if (c=='\n')
            printf("%6d\t%3d\tnewline\n",i,c);
        else if (c=='\t')
            printf("%6d\t%3d\ttab\n",i,c);
        else if (c=='\0')
            printf("%6d\t%3d\tNUL\n",i,c);
        else
            printf("%6d\t%3d\t _ \n",i,c);
        c = getc(stdin);
        ++i;
    }
    return 0;
}
