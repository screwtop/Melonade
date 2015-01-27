# Browser/inspector for actions scheduled by [after]

toplevel .afters; wm title .afters {[after] Schedules}
ttk::treeview .afters.tree -columns {Script} -selectmode browse
pack .afters.tree -expand 1 -fill both
.afters.tree heading #0 -text after
.afters.tree heading #1 -text Script

proc refresh_after_tree {} {
	# TODO: wasn't there a simpler way to do this that I found, avoiding the loop?
	foreach after [.afters.tree children {}] {.afters.tree delete $after}
	foreach after [lsort [after info]] {
		set ::after_treeview_node($after) [.afters.tree insert {} end -text $after]
		foreach {body} [after info $after] {
			.afters.tree insert $::after_treeview_node($after) end -values [list $body]
		}
	}
}

# every 1000 refresh_after_tree
pack [button .afters.refresh_button -text Refresh -command refresh_after_tree] -side bottom -fill x
# TODO: scrollbar

refresh_after_tree

