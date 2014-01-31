# List of commands defined using "proc", i.e. script-based, not compiled commands.

toplevel .procs; wm title .procs Procs
ttk::treeview .procs.tree -columns {Arguments} -selectmode browse
pack .procs.tree -expand 1 -fill both
.procs.tree heading #0 -text Proc
.procs.tree heading #1 -text Args

proc clear_proc_tree {} {foreach proc [.procs.tree children {}] {.procs.tree delete $proc}}

proc populate_proc_tree {} {
	foreach proc_name [lsort [info procs]] {
	#	puts -nonewline "proc $proc_name"
	#	puts -nonewline " {[info args $proc_name]} {"
	#	puts [info body $proc_name]
	#	puts "}"
		.procs.tree insert {} end -text $proc_name -values [list [info args $proc_name]]
	}
}

proc refresh_proc_tree {} {
	clear_proc_tree
	populate_proc_tree
}

populate_proc_tree

# Separate window for viewing the actual procedure definition:

#toplevel .proc_body
# ...


# every 1000 refresh_proc_tree
pack [button .procs.refresh_button -text Refresh -command refresh_proc_tree] -side bottom -fill x

