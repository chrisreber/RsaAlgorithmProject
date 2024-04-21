all: RSA

MYLIB=RSALib.o
CC=gcc

RSA: RSA.o $(MYLIB)
	$(CC) $@.o $(MYLIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

