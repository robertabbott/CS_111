CC = gcc
WERROR_CFLAGS = -Werror
CFLAGS = -g
LAB = design-problem
DISTDIR = fsFixer-$(USER)
TAR = tar
TAR_FLAGS = --numeric-owner --owner=0 --group=0 --mode=go+u,u+w,go-w

all: fsFixer

TESTS_SOURCES = test.c

TESTS_OBJECTS = $(subst .c,.o,$(TESTS_SOURCES))

FSFIXER_SOURCES = \
  ospfs-fsck.c \
  ospfs-fsckmod.c

FSFIXER_OBJECTS = $(subst .c,.o,$(FSFIXER_SOURCES))

DIST_SOURCES = \
  $(FSFIXER_SOURCES) ospfs-fsck.h Makefile \
  $(TESTS_SOURCES) test.sh README fs.img

test: $(TESTS_OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(TESTS_OBJECTS)

fsFixer: $(FSFIXER_OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(FSFIXER_OBJECTS)

ospfs-fsck.o ospfs-fsckmod.o: ospfs-fsck.h

dist: $(DISTDIR).tar.gz

$(DISTDIR).tar.gz: $(DIST_SOURCES)
	rm -fr $(DISTDIR)
	$(TAR) $(TAR_FLAGS) -czf $@.tmp --transform='s,^,$(DISTDIR)/,' \
	  $(DIST_SOURCES)
	mv $@.tmp $@

Skeleton: $(DIST_SOURCES)
	$(MAKE) CHECK_DIST=: USER=$@ lab1-$@.tar.gz

check: $(TEST_BASES)

$(TEST_BASES): profsh
	./$@.sh

clean:
	rm -fr *.o *~ *.bak *.tar.gz core *.core *.tmp fsFixer $(DISTDIR)

.PHONY: all dist check $(TEST_BASES) clean Skeleton
