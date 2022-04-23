CC = clang
CFLAGS = -O0 -Wall

.PHONY = clean

all: ishow bytes

ishow: ishow.c
	$(CC) $(CFLAGS) -o ishow ishow.c

bytes: bytes.c
	$(CC) $(CFLAGS) -o bytes bytes.c

clean: 
	rm -f *.o bytes ishow *~
