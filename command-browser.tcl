# I'm calling this a browser rather than inspector because the list of commands doesn't have any extra attributes to inspect.  I don't think...
# Maybe I should call it an inspector for consistency and in case it ends up having more functionality...

toplevel .commands; wm title .commands commands
ttk::treeview .commands.tree -selectmode browse
pack .commands.tree -expand 1 -fill both
.commands.tree heading #0 -text command


proc clear_command_tree {} {foreach command [.commands.tree children {}] {.commands.tree delete $command}}


proc populate_command_tree {} {
	foreach command [lsort [info commands]] {
		.commands.tree insert {} end -text $command
	}
}


proc refresh_command_tree {} {
	clear_command_tree
	populate_command_tree
}

# every 1000 refresh_command_tree
pack [button .commands.refresh_button -text Refresh -command refresh_command_tree] -side bottom -fill x

refresh_command_tree



