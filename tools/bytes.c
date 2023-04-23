#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

/*
Acknowledgement:

This utility is courtesy of Dr. Adam Shaw, provided during CMSC 15200 in Winter
quarter of 2022 at the University of Chicago. I have modified it slightly to
add binary string functionality and prettier output.
 
 */

char *get_binary_string(unsigned char uc)
{
// returns a heap-allocated string of all 1s and 0s
// that represent the given number.
    char *binstr=(char *)malloc(9*sizeof(char));
    if(!binstr){
        fprintf(stderr, "get_binary_string: allocation failed\n");
        exit(1);
    }
    for(int i=0; i<8; i++){
        int digit = (uc >> (7-i)) & 1;
        sprintf(binstr+i,"%d",digit);   
    }
    binstr[9] = '\0';
    return binstr;
}


// display a file one byte at a time
int main(int argc, char *argv[])
{
    int i = 0;
    int c = getc(stdin);
    printf(" index\tchar\thex\tdec.\tbinary\n");
    while (c!=EOF) {
        char *bin = get_binary_string(c);
        if (isgraph(c) || c==' ')
            printf("%6d\t%c\t%02X\t%3d\t%s\n",i,c,c,c,bin);
        else if (c=='\n')
            printf("%6d\tnewline\t%02X\t%3d\t%s\n",i,c,c,bin);
        else if (c=='\t')
            printf("%6d\ttab\t%02X\t%3d\t%s\n",i,c,c,bin);
        else if (c=='\0')
            printf("%6d\tNUL\t%02X\t%3d\t%s\n",i,c,c,bin);
        else
            printf("%6d\t[%d]\t%02X\t%3d\t%s\n",i,c,c,c,bin);
        
        free(bin);
        c = getc(stdin);
        ++i;
    }
    return 0;
}
