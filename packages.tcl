# List of packages (currently only those that are loaded).

# TODO: use [package names] to get a list of available packages.

toplevel .packages; wm title .packages Packages
ttk::treeview .packages.tree -columns {Path} -selectmode browse
pack .packages.tree -expand 1 -fill both
.packages.tree heading #0 -text Package
.packages.tree heading #1 -text Path

proc clear_package_tree {} {foreach package [.packages.tree children {}] {.packages.tree delete $package}}


proc populate_package_tree {} {
	# List details of loaded packages:
	# TODO: sort these by (case-insensitive) package name?
	foreach package [lsort [info loaded]] {
	#	puts stderr $package
		lassign $package package_file package_name
		.packages.tree insert {} end -text $package_name -values [list $package_file]
	}
}


proc refresh_package_tree {} {
	clear_package_tree
	populate_package_tree
}

# every 1000 refresh_package_tree
pack [button .packages.refresh_button -text Refresh -command refresh_package_tree] -side bottom -fill x

refresh_package_tree

