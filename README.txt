This is Melonade, a set of debugging/development tools for Tcl/Tk.  These are intended to be sourced from a running tclsh/wish to provide functionality such as browsing variables, editing procs, viewing widget hierarchies, and other things that might be useful for interactive development using Tcl/Tk.

To install:
sudo make install

If you have multiple Tcl installations and want to install for a specific one other than the default:
sudo make install TCL_VERSION=8.6
