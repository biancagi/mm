# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# the name of the compiler
compiler.c++ := g++

# prefices for specific categories
g++.prefix.flags :=
g++.prefix.defines := -D
g++.prefix.incpath := -I

g++.prefix.ldflags :=
g++.prefix.libpath := -L
g++.prefix.libraries := -l

# compile time flags
g++.compile.only := -c
g++.compile.output := -o
g++.compile.makedep := -MMD
g++.compile.base := -fno-diagnostics-color -pipe $(g++.compile.makedep)

# symbols and optimization
g++.debug := -g
g++.opt := -O3
g++.cov := --coverage
g++.prof := -pg
g++.shared := -fPIC

# language level
g++.std.c++98 := -std=c++98
g++.std.c++11 := -std=c++11
g++.std.c++14 := -std=c++14
g++.std.c++17 := -std=c++17

# link time flags
g++.link.output := -o
g++.link.shared :=
# link a dynamically loadable library
g++.link.dll := -shared

# command line options
g++.defines = MM_COMPILER_gcc

# clean up temporaries left behind while compiling
#  usage: g++.clean {base-name}
g++.clean = $(1).d

# dependency generation
# g++ does this in one pass: the dependency file gets generated during the compilation phase so
# there is no extra step necessary to build it
#   usage: g++.makedep {source} {depfile} {external dependencies}
define g++.makedep =
    $(cp) $(2) $(2).tmp ; \
    $(sed) \
        -e 's/\#.*//' \
        -e 's/^[^:]*: *//' \
        -e 's/ *\\$$$$//' \
        -e '/^$$$$/d' \
        -e 's/$$$$/ :/' \
        $(2) >> $(2).tmp ; \
    $(mv) $(2).tmp $(2)
endef


# end of file
