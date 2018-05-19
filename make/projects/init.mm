# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- project.init}

# meta-data for all projects
project.contentTypes := libraries extensions packages docs tests

# the project constructor
#   usage: project.init {name}
define project.init =
    # save the name
    $(project).name := $(project)

    # directories
    # the top-most directory where we found {.mm}
    $(project).home := $(project.home)
    # the directory for build products
    $(project).bldroot := $(project.bldroot)
    # the installation target directory
    $(project).prefix := $(project.prefix)
    # the staging area for the build intermediate products
    $(project).tmpdir := $(builder.tmpdir)/$(project)

    # make
    # the directory from where {make} was invoked, i.e. the nearest parent with a local
    # makefile
    $(project).base := $(project.anchor)
    # the user's {cwd} when they invoked mm
    $(project).origin := $(project.origin)
    # the local makefile
    $(project).makefile := $(project.makefile)
    # the project configuration file
    $(project).config := ${wildcard $(project.config)/$(project).mm}

    # dependencies
    # initialize the list of requested project dependencies
    $(project).extern.requested ?=
    # the list of external dependencies that we have support for
    $(project).extern.supported ?=
    # the list of dependecies in the order they affect the compiler command lines
    $(project).extern.available ?=

    # contents
    # initialize the list of libraries
    $(project).libraries ?=
    # the list of python extenions
    $(project).extensions ?=
    # the list of python packages
    $(project).packages ?=
    # documentation
    $(project).docs ?=
    # and the list of tests
    $(project).tests ?=

    # documentation
    # the project metedata categories
    $(project).meta.categories := contents extern directories make

    # build a list of all the project attributes by category
    $(project).meta.directories := home bldroot prefix tmpdir
    $(project).meta.make := base origin makefile config
    $(project).meta.extern := extern.requested extern.supported extern.available
    $(project).meta.contents := $(project.contentTypes)

    # category documentation
    $(project).metadoc.directories := "the layout of the build directories"
    $(project).metadoc.contents := "categories of build products"
    $(project).metadoc.extern := "dependencies to external packages"
    $(project).metadoc.make := "information about the builder"

    # document each one
    $(project).metadoc.name := "the name of the project"
    # directories
    $(project).metadoc.home := "the top level project directory"
    $(project).metadoc.bldroot := "the directory where build products get delivered"
    $(project).metadoc.prefix := "the install target directory"
    $(project).metadoc.tmpdir := "the directory with the intermediate build products"
    # make
    $(project).metadoc.base := "the directory from which mm invoked make"
    $(project).metadoc.origin := "the directory from which you invoked mm"
    $(project).metadoc.makefile := "the local makefile"
    $(project).metadoc.config := "the project configuration file"
    # dependencies
    $(project).metadoc.extern.requested := "requested dependencies"
    $(project).metadoc.extern.supported := "the dependencies for which there is mm support"
    $(project).metadoc.extern.available := "dependencies that were actually found and used"
    # contents
    $(project).metadoc.libraries := "the project libraries"
    $(project).metadoc.extensions := "the python extensions built by this project"
    $(project).metadoc.packages := "the python pyckages built by this project"
    $(project).metadoc.docs := "documentation for this project"
    $(project).metadoc.tests := "the project test suite"
# all done
endef

# scan through the project contents and collect all the requested dependencies
# usage project.requestedDependencies {names}
define project.requestedDependencies =
    # go through the list of project names
    ${foreach project, $(1),
        ${eval $(1).extern.requested :=
            # and the types of contents
            ${foreach item, $($(1).meta.contents),
                # asking each one for the requested external packages
                $($(1).$(item).extern.requested)
            }
        }
    }
# all done
endef

# identify the list of dependencies for which there is support
# usage project.supportedDependencies {name}
define project.supportedDependencies =
# all done
endef

# show me
# ${info -- done with project.init}

# end of file