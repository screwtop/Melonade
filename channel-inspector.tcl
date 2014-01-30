# Channel browser for Melonade

# Commands to make use of:
# chan names
# chan configure file9
# chan pending output stderr
# chan eof?

toplevel .channels; wm title .channels Channels
ttk::treeview .channels.tree -columns {Attribute Value} -selectmode browse
pack .channels.tree -expand 1 -fill both
.channels.tree heading #0 -text Channel
.channels.tree heading #1 -text Attribute
.channels.tree heading #2 -text Value

# Maybe "refresh_channel_tree" and have it clear out the existing entries first?
proc refresh_channel_tree {} {
	foreach channel [.channels.tree children {}] {.channels.tree delete $channel}
	foreach channel [chan names] {
#		puts $channel
		set ::channel_treeview_node($channel) [.channels.tree insert {} end -text $channel]
		foreach {attribute value} [chan configure $channel] {
		#	puts "$attribute = $value"
			.channels.tree insert $::channel_treeview_node($channel) end -values [list $attribute $value]
		}
	}
}

# every 1000 refresh_channel_tree
pack [button .channels.refresh_button -text Refresh -command refresh_channel_tree] -side bottom -fill x

refresh_channel_tree

