# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- libraries.info}


# library help
# make the recipe
libraries.info: mm.banner
	$(log) "known libraries: "$(palette.purple)$(libraries)$(palette.normal)
	$(log)
	$(log) "to build one of them, use its name as a target"
	$(log) "    mm ${firstword $(libraries)}"
	$(log)
	$(log) "to get more information about a specific library, use"
	$(log) "    mm ${firstword $(libraries)}.info"
	$(log)


# bootstrap
# make the library specific targets
#  usage: library.workflows {library}
define libraries.workflows =
    # build recipes
    ${call library.workflows.build,$(1)}
    # info recipes: show values
    ${call library.workflows.info,$(1)}
    # help recipes: show documentation
    ${call library.workflows.help,$(1)}
# all done
endef


# build targets
# target factory for building a library
#   usage: library.workflows.build {library}
define library.workflows.build =
# the main recipe
$(1): $(1).directories $(1).assets
	${call log.asset,"lib",$(1)}

$(1).directories: $($(1).libdir) $($(1).staging.incdirs) $($(1).tmpdir)

${if ${findstring $($(1).libdir),$(builder.libdir)},,$($(1).libdir)} \
$($(1).staging.incdirs) $($(1).tmpdir):
	$(mkdirp) $$@
	${call log.action,"mkdir",$$@}

$(1).assets: $(1).headers $(1).archive

$(1).headers: $($(1).staging.headers)

# make the rules that publish the exported headers
${foreach header, $($(1).headers), \
    ${eval ${call library.workflows.header,$(1),$(header)}}
}

$(1).archive: $($(1).staging.archive)

$($(1).staging.archive): $($(1).staging.objects)
	$(ar.create) $$@ $($(1).staging.objects)
	${call log.action,"ar",$($(1).archive)}

# make the rules that compile the archive sources
${foreach source,$($(1).sources), \
    ${eval ${call library.workflows.object,$(1),$(source)}}
}

# include the dependency files
-include $($(1).staging.objects:$(builder.ext.obj)=$(builder.ext.dep)) \

# all done
endef


# helpers
# library headers
#  usage: library.workflows.header {library} {header}
define library.workflows.header =
# publish public headers
${call library.staging.header,$(1),$(2)}: $(2) | ${call library.staging.incdir,$(1),$(2)}
	$(cp) $$< $$@
	${call log.action,"publish",${subst $($($(1).project).home)/,,$(2)}}
# all done
endef


# library objects
#  usage: library.workflows.object {library} {source}
define library.workflows.object =

    # compute the absolute path of the source
    ${eval source.path := $(2)}
    # and the path to the object module
    ${eval source.object := ${call library.staging.object,$(1),$(2)}}
    # figure out the source language
    ${eval source.language := $(ext${suffix $(2)})}

# compile source files
$(source.object): $(source.path)
	${call log.action,"$(source.language)",${subst $($($(1).project).home)/,,$(source)}}
	${call \
            languages.$(source.language).compile, \
            $(source.path),$(source.object),$($(1).extern)\
        }
	${if $($(compiler.$(source.language)).compile.generate-dependencies), \
            $(cp) $$(@:$(builder.ext.obj)=$(builder.ext.dep)) $$@.$$$$ ; \
            $(sed) \
                -e 's/\#.*//' \
                -e 's/^[^:]*: *//' \
                -e 's/ *\\$$$$//' \
                -e '/^$$$$/d' \
                -e 's/$$$$/ :/' \
                $$(@:$(builder.ext.obj)=$(builder.ext.dep)) \
                    < $$(@:$(builder.ext.obj)=$(builder.ext.dep)) >> $$@.$$$$ ; \
            $(mv) $$@.$$$$ $$(@:$(builder.ext.obj)=$(builder.ext.dep)), \
        }

# all done
endef


# make a recipe to log the metadata of a specific library
# usage: library.workflows.info {library}
define library.workflows.info =
# make the recipe
$(1).info:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	$(log)
	${call log.var,headers,$($(1).incdir)}
	${call log.var,archive,$($(1).staging.archive)}
	${call log.var,source root,$($(1).prefix)}
	${call log.var,requested packages,$($(1).extern.requested)}
	${call log.var,supported packages,$($(1).extern.supported)}
	${call log.var,available packages,$($(1).extern.available)}
	$(log)
	$(log) "for an explanation of their purpose, try"
	$(log)
	$(log) "    mm $(1).help"
	$(log)
	$(log) "related targets:"
	$(log)
	${call log.help,$(1).info.directories,"the layout of the source directories"}
	${call log.help,$(1).info.sources,"the source files"}
	${call log.help,$(1).info.headers,"the header files"}
	${call log.help,$(1).info.incdirs,"the include directories in the staging area"}
	${call log.help,$(1).info.api,"the exported public headers"}
	${call log.help,$(1).info.objects,"the object files in the staging area"}


# make a recipe that prints the directory layout of the sources of a library
$(1).info.directories:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  source directories",}
	${foreach directory,$($(1).directories),$(log) $(log.indent)$(directory);}


# make a recipe that prints the set of sources that comprise a library
$(1).info.sources:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  sources",}
	${foreach source,$($(1).sources),$(log) $(log.indent)$(source);}


# make a recipe that prints the set of public headers of a library
$(1).info.headers:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.sec,"  headers",}
	${foreach header,$($(1).headers),$(log) $(log.indent)$(header);}
# all done

# make a recipe that prints the set of objects of a library
$(1).info.objects:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.var,"tmpdir",$($(1).tmpdir)}
	${call log.sec,"  objects",}
	${foreach object,$($(1).staging.objects),$(log) $(log.indent)$(object);}


# make a recipe that prints the set of includes of a library
$(1).info.incdirs:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.var,"incdir",$($(1).incdir)}
	${call log.sec,"  include directory structure",}
	${foreach directory,$($(1).staging.incdirs),$(log) $(log.indent)$(directory);}

# make a recipe that prints the set of exported public headers
$(1).info.api:
	${call log.sec,$(1),"a library in project '$($(1).project)'"}
	${call log.var,"incdir",$($(1).incdir)}
	${call log.sec,"  exported public headers",}
	${foreach header,$($(1).staging.headers),$(log) $(log.indent)$(header);}

# all done
endef


# make a recipe to show the metadata documentation of a specific library
# usage: library.workflows.help {library}
define library.workflows.help =
# make the recipe
$(1).help:
	$(log)
	${call log.sec,$(1),library attributes}
	$(log)
	${foreach category,$($(1).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).metadoc.$(var))}; \
             } \
        } \
	$(log)
	$(log) "for a listing of their values, try"
	$(log)
	$(log) "    mm $(1).info"
	$(log)
# all done
endef


# show me
# ${info -- done with libraries.info}

# end of file
