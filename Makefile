#TCL_VERSION = 8.6
# NOTE: If the env command below fails, Make simply proceeds, resulting in trying to install the package into "/"!
# Ideally we would halt the make process if that happens.  Somehow.
# For now, default to somewhere safe-ish like /usr/local/lib/tcl.
# Bah, only that doesn't work, because TCL_LIB_PATH always has a value (even if it's just blank).
TCL_LIB_PATH = $(shell echo "puts [info library]" | /usr/bin/env tclsh$(TCL_VERSION))
TCL_LIB_PATH ?= /usr/local/lib/tcl
MELONADE_VERSION = 0.0
INSTALL_PATH = $(TCL_LIB_PATH)/melonade$(MELONADE_VERSION)

install: melonade *.tcl
	mkdir -p $(INSTALL_PATH)
	cp -v melonade *.tcl $(INSTALL_PATH)
