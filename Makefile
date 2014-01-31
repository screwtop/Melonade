# How to figure out installation destination?!  Should be somewhere in $auto_path
# To determine Tcl version:
# echo "puts [info tclversion]" | /usr/bin/env tclsh
# On my 8.6-built-from-source system it's:
# /usr/local/src/tcl8.6.1/unix/tclConfig.sh
# /usr/local/lib/tcl8.6/

TCL_LIB_PATH=/usr/local/lib/tcl8.6
MELONADE_VERSION=0.0
INSTALL_PATH=$(TCL_LIB_PATH)/melonade$(MELONADE_VERSION)

install: melonade
	mkdir -p $(INSTALL_PATH)
	cp -v melonade *.tcl $(INSTALL_PATH)
