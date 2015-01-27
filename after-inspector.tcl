# Browser/inspector for actions scheduled by [after]

toplevel .afters; wm title .afters {[after] Events Scheduled}
ttk::treeview .afters.tree -columns {Type Script} -selectmode browse
pack .afters.tree -expand 1 -fill both
.afters.tree heading #0 -text ID; .afters.tree column #0 -minwidth 100 -width 100 -stretch 0
.afters.tree heading #1 -text Type; .afters.tree column #1 -minwidth 80 -width 80 -stretch 0
.afters.tree heading #2 -text Script

proc refresh_after_tree {} {
	# TODO: wasn't there a simpler way to do this that I found, avoiding the loop?
	foreach after [.afters.tree children {}] {.afters.tree delete $after}
	foreach after [lsort [after info]] {
		set ::after_treeview_node($after) [.afters.tree insert {} end -text $after]
		foreach {script type} [after info $after] {
			.afters.tree insert $::after_treeview_node($after) end -values [list $type $script]
		}
	}
}

# every 1000 refresh_after_tree
pack [button .afters.refresh_button -text Refresh -command refresh_after_tree] -side bottom -fill x
# TODO: scrollbar

refresh_after_tree

