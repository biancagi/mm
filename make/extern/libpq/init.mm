# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# add me to the pile
extern += ${if ${findstring libpq,$(extern)},,libpq}

# compiler flags
libpq.flags ?=
# enable {libpq} aware code
libpq.defines := WITH_LIBPQ
# the canonical form of the include directory
libpq.incpath ?= $(libpq.dir)/include

# linker flags
libpq.ldflags ?=
# the canonical form of the lib directory
libpq.libpath ?= $(libpq.dir)/lib
# the names of the libraries
libpq.libraries := libpq

# my dependencies
libpq.dependencies =

# end of file