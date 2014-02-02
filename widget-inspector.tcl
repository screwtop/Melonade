# CME 2014-01-30
# Just thinking it might be kinda nice to have a Tcl/Tk GUI inspector/editor, much like what you have in Microsoft Access.
# Could be the start of a broader IDE...I'd think that in principle a highly introspective dynamic GUI/debugger/editor for Tcl in Tcl would be a dream to build.  Could include: view/add/modify/delete variables [info vars][set][unset], procedure browser/editor [info procs][info body], loaded packages [info loaded] [package names], channel browser [chan names], variable watches using [trace], timing and profiling, ...!!!

# In the meantime, you can just source this into an existing program to be able to graphically browse the widget hierarchy and see each widget's "configure" properties.

# Elements: [winfo], events and variable traces for keeping things up-to-date, 
# Things you might wanna browse: geometry, colours, fonts, event bindings, 

# package require Tk

toplevel .widgets; wm title .widgets Widgets
ttk::treeview .widgets.tree -columns {Class ID Name} -selectmode browse
pack .widgets.tree -expand 1 -fill both
.widgets.tree heading #0 -text Widget
.widgets.tree heading #1 -text Class
.widgets.tree heading #2 -text ID
.widgets.tree heading #3 -text Name

# We store the mapping from widget IDs to treeview element IDs in this array:
set ::treeview_id(.) {}	;# The treeview uses the empty string to identify the root of the tree.

proc populate_widget_tree {parent} {
	# TODO: should these be sorted in alphabetical order?  If we leave them in the order that they are returned, does that indicate the order in which they were created, or the order in which they appear on the GUI?
	foreach widget [winfo children $parent] {
		set ::treeview_id($widget) [.widgets.tree insert $::treeview_id($parent) end -text $widget -values [list [winfo class $widget] [winfo id $widget] [winfo name $widget]]]
		# We also want a map going the other way (treeview ID -> widget window name):
		set ::widget_name($::treeview_id($widget)) $widget
		# TODO: a proc for grabbing all the info about a widget, structured "appropriately".
		populate_widget_tree $widget	;# Recurse
	}
}

proc clear_widget_tree {} {
        foreach widget [.widgets.tree children {}] {
                .widgets.tree delete $widget
	}
	# Also remove the arrays mapping between widget names and treeview node IDs:
	array unset ::treeview_id
	array unset ::widget_name
	set ::treeview_id(.) {}	;# Oh, but restore the phony root element
}

proc refresh_widget_tree {} {
	clear_widget_tree
	populate_widget_tree .
}

# TODO: have it manually refreshed for now?  Provide a button?
pack [button .widgets.refresh_button -text Refresh -command refresh_widget_tree] -side bottom -fill x

# Attributes that might be handy.  The most common ones should appear on the list, with the option to expand to show more detail (or have a separate property window for the full detail - remember that a lot of them will be common to all/most widgets)
winfo class .widgets.tree
winfo id .widgets.tree
winfo width .widgets.tree
winfo name .widgets.tree


# Dunt da-dunt da-dunt, Inspector Widget...
toplevel .inspector; wm title .inspector Inspector	;# Conspicuously, the window title does not appear in the attributes of the toplevel!  We might need some additional stuff for this ([wm attributes], [wm title], [wm state], etc.)
# I think a treeview without the tree is the way to do tables, yes?
# Note: it's actually a 5-element list for each "configure" attribute, but we probably only need two.
ttk::treeview .inspector.table -columns {Attribute Value} -show {headings}
pack .inspector.table -expand 1 -fill both
.inspector.table heading #0 -text Widget
.inspector.table heading #1 -text Attribute
.inspector.table heading #2 -text Value

# Populate the Inspector table with the "conigure" properties of the specified widget:
proc populate_inspector_table {widget} {
	# Clear the property sheet first:
	# How come we can't just go:
	#.inspector.table delete {}
	# Well, you just can't delete the root item.  This'll have to do:
	foreach item [.inspector.table children {}] {.inspector.table delete $item}
	foreach item [$widget configure] {
	#	puts "<<$item>>"
		# List items 2 and 4 are "important" name and current value.
		# Oh, but some properties only have two items....?!  We'll just ignore those for now
		# "Each entry in the list will contain either two or five values. If the corresponding entry in specs has type TK_CONFIG_SYNONYM, then the list will contain two values: the argvName for the entry and the dbName (synonym name). Otherwise the list will contain five values: argvName, dbName, dbClass, defValue, and current value."
		# Also, some have 5 items but are empty apart from the first (e.g. -startline).  Should handle those better.
		if {[llength $item] == 2} {continue}	;# Skip aliases
		lassign $item option name class default value
		.inspector.table insert {} end -text $widget -values [list $option $value]
	}
}

# TODO: there's the top-level configure, but often also itemconfigure for each item in the widget...




# Now set up events so that the Inspector shows information for the selected widget in the main Widget Browser:
bind .widgets.tree <<TreeviewSelect>> {
	populate_inspector_table $::widget_name([.widgets.tree selection])
}


# Refreshing these will introduce some interesting problems.  A simplistic approach would be to clear everything out and rebuild from what's there now, but that would lose the treeview item open/closed states and might be flickery.

refresh_widget_tree

