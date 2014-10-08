#

ARCHLIB=$(shell perl -MConfig -e 'print $$Config{archlib}')
CC=$(shell perl -MConfig -e 'print $$Config{cc}, "\n"')
CCFLAGS=$(shell perl -MConfig -e 'print $$Config{ccflags}')
LDFLAGS=$(shell perl -MConfig -e 'print $$Config{ldflags}')

all: perlstub.so 

clean:
	-rm -f *~
	rm -f perlstub.so

perlstub.so: perlstub.c
	 $(CC) -o perlstub.so -shared perlstub.c -lperl -I $(ARCHLIB)/CORE -fPIC $(CCFLAGS)

