# A variable list/inspector for Melonade

# How to distinguish ordinary variables from arrays? (note that [info vars] includes arrays)  What about dicts?  Might we care about lists also (at least report [llength] maybe)?
# [info vars] [info exists] [array exists] [set]
# What about namespaces?!

toplevel .variables; wm title .variables Variables
ttk::treeview .variables.tree -columns {Value} -selectmode browse
pack .variables.tree -expand 1 -fill both
.variables.tree heading #0 -text Variable
.variables.tree heading #1 -text Value

proc clear_variable_tree {} {foreach variable [.variables.tree children {}] {.variables.tree delete $variable}}

proc populate_variable_tree {} {
	uplevel #0 {
		foreach variable [lsort [info vars]] {
		#	puts stderr $variable
			if [array exists $variable] {
				# It's an array - do we just report that it is, or try to give an indication of what it contains?  [array size] [array names] [array get]?!
				.variables.tree insert {} end -text $variable -values [list "\[array, size [array size $variable]\]"]
				# Maybe add the array values as children of the variable in the treeview?
			} else {
				# It's an ordinary variable
				.variables.tree insert {} end -text $variable -values [list [set $variable]]
				# TODO: report list length, string length of the variable's value?
			}
		}
	}
}

proc refresh_variable_tree {} {
	clear_variable_tree
	populate_variable_tree
}

# every 1000 refresh_variable_tree
pack [button .variables.refresh_button -text Refresh -command refresh_variable_tree] -side bottom -fill x

