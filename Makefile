#
LIBNAME =iwi
LIBSUFFIX =.so

# common prefix 
INCS =-I/usr/local/include -I/usr/include -I../luajit-2.0/src -I../libgeohash/include
LIBSDIR =-L/usr/local/lib -L/usr/lib -L../luajit-2.0/src/ -L../libgeohash/build/lib

# basic setup
CC =gcc
LIBS =$(LIBSDIR) -lm -lgeohash
OPTS =-O3 -Wall
LIBOPT =-c
CFLAGS =$(LIBOPT) $(OPTS) $(INCS) -fPIC
CFLAGS_LIB =$(SHARE) $(OPTS) $(LIBS) $(INCS)

.PHONY: all release clean debug

all: $(LIBNAME)$(LIBSUFFIX) $(LIBNAME).o clean_obj

$(LIBNAME)$(LIBSUFFIX): $(LIBNAME).o
	$(CC) -o $@ $^ $(CFLAGS_LIB)

$(LIBNAME).o: $(LIBNAME).c
	$(CC) -o $@ $^ $(CFLAGS)

release: $(LIBNAME)$(LIBSUFFIX) clean_obj
	$(if $(shell which strip), strip $<)
	$(if $(shell which upx), upx --best $<)

clean:
	\rm -f *.o *.dll *.so

clean_obj:
	[ -f $(LIBNAME).o ] && \rm $(LIBNAME).o

debug: CC += -DDEBUG
debug: all