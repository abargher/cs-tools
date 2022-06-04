/*

Acknowledgement:
This tool is from the University of Chicago CMSC 15400 teaching staff in the 
Spring quarter of 2022. It was included in the Project 1 materials as an
assistive tool.

Thank you to Madison Pickering (Project 1 TA), Prof. Yanjing Li, and
Prof. Junchen Jiang for providing this source code.

I have added in the binary string functionality, the original tool did not
display numbers in binary format.

The included Project 1 Makefile originally compiled this program as follows:
    gcc -O0 -Wall -o ishow ishow.c

*/

/* Display value of fixed point numbers */
#include <stdlib.h>
#include <stdio.h>

/* Extract hex/decimal/or float value from string */
static int get_num_val(char *sval, unsigned *valp) {
  char *endp;
  /* See if it's an integer or floating point */
  int ishex = 0;
  int isfloat = 0;
  int i;
  for (i = 0; sval[i]; i++) {
    switch (sval[i]) {
    case 'x':
    case 'X':
      ishex = 1;
      break;
    case 'e':
    case 'E':
      if (!ishex)
	isfloat = 1;
      break;
    case '.':
      isfloat = 1;
      break;
    default:
      break;
    }
  }
  if (isfloat) {
    return 0; /* Not supposed to have a float here */
  } else {
    long long int llval = strtoll(sval, &endp, 0);
    long long int upperbits = llval >> 31;
    /* will give -1 for negative, 0 or 1 for positive */
    if (valp && (upperbits == 0 || upperbits == -1 || upperbits == 1)) {
      *valp = (unsigned) llval;
      return 1;
    }
    return 0;
  }
}

char *get_binary_string(unsigned uf)
{
// returns a heap-allocated string of all 1s and 0s
// that represent the given number.
    char *binstr=(char *)malloc(33*sizeof(char));
    if(!binstr){
        fprintf(stderr, "get_binary_string: allocation failed\n");
        exit(1);
    }
    for(int i=0; i<32; i++){
        int digit = (uf >> (31-i)) & 1;
        sprintf(binstr+i,"%d",digit);   
    }
    binstr[32] = '\0';
    return binstr;
}

void show_int(unsigned uf)
{
    char *bin = get_binary_string(uf);
    printf("Hex = 0x%.8x,  Signed = %d,  Unsigned = %u,\nBinary = %s\n",
           uf,(int)uf,uf,bin);
    free(bin);
}


void usage(char *fname) {
  printf("Usage: %s val1 val2 ...\n", fname);
  printf("Values may be given in hex or decimal\n");
  exit(0);
}


int main(int argc, char *argv[])
{
  int i;
  unsigned uf;
  if (argc < 2)
    usage(argv[0]);
  for (i = 1; i < argc; i++) {
    char *sval = argv[i];
    if (get_num_val(sval, &uf)) {
      show_int(uf);
    } else {
      printf("Cannot convert '%s' to 32-bit number\n", sval);
    }
  }
  return 0;
}
