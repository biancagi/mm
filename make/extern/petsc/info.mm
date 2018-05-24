# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the petsc configuration
petsc.info:
	${call log.sec,"petsc",}
	${call log.var,"version",$(petsc.version)}
	${call log.var,"configuration file",$(petsc.config)}
	${call log.var,"home",$(petsc.dir)}
	${call log.var,"compiler flags",$(petsc.flags)}
	${call log.var,"defines",$(petsc.defines)}
	${call log.var,"incpath",$(petsc.incpath)}
	${call log.var,"linker flags",$(petsc.ldflags)}
	${call log.var,"libpath",$(petsc.libpath)}
	${call log.var,"libraries",$(petsc.libraries)}
	${call log.var,"dependencies",$(petsc.dependencies)}
	${call log.var,"c++ compile line",${call extern.compile.options,c++,petsc}}
	${call log.var,"c++ link line",${call extern.link.options,c++,petsc}}

# end of file