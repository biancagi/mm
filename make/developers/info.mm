# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- developers.info}

# developer info
developer.info:
	${call log.sec,"developer", "user specific options and overrides"}
	${call log.var,compiler choices,$(developer.$(developer).compilers)}
	${foreach \
            language, \
            $(languages),\
            ${call log.sec, "  $(language) options",}; \
            ${foreach \
                category, \
                $(languages.$(language).categories), \
                ${call log.var,$(category), $(developers.$(developer).$(language).$(category))}; \
            } \
        }

# show me
# ${info -- done with developers.info}

# end of file
