CC = clang
CFLAGS = -O0 -Wall

.PHONY = clean

all: clean ishow bytes colorpatch ncol

ishow: ishow.c
	$(CC) $(CFLAGS) -o ishow ishow.c

bytes: bytes.c
	$(CC) $(CFLAGS) -o bytes bytes.c

colorpatch: colorpatch.c
	$(CC) $(CFLAGS) -o colorpatch colorpatch.c

ncol: ncol.c
	$(CC) $(CFLAGS) -lm -o ncol ncol.c
clean: 
	rm -f *.o bytes ishow colorpatch *~
