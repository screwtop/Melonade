# A simple command console window.
# Could imagine wanting file management, text editing in here alone!  At least a command history.
# Would be nicer if we could just have tclsh + rlwrap in a terminal like we get when starting it up manually.
# Should also be possible to show/hide.
# TODO: make it work with commands containing quoted/braced spaces!
# TODO: find out if stdout can be appended to the output text widget
# TODO: find out if stdout and stderr can be handled separately (different colours, different text widget?)

set ::melonade::console_history_index 0

toplevel .console
wm title .console Console

set ::melonade::settings::consolefont {LetterGothic12Pitch 10}

pack [entry .console.entry -textvar command -font $::melonade::settings::consolefont] -fill x -side top
bind .console.entry <Key-Return> {execute %W}
bind .console.entry <Key-Up> {
	incr ::melonade::console_history_index
	if {$::melonade::console_history_index > [llength $::melonade::console_history]} {set ::melonade::console_history_index [llength $::melonade::console_history]}
	set command [lindex $::melonade::console_history end-$::melonade::console_history_index]
	.console.entry icursor end
}
bind .console.entry <Key-Down> {
	incr ::melonade::console_history_index -1
	if {$::melonade::console_history_index < 0} {
		set ::melonade::console_history_index -1
		set command ""
	} else {
		set command [lindex $::melonade::console_history end-$::melonade::console_history_index]
	}
	.console.entry icursor end
}

pack [text .console.output -wrap word] -fill both -expand 1
.console.output configure -font $::melonade::settings::consolefont -background black -foreground #00ff00

set ::melonade::console_history [list]

proc execute {w} {
	global command
	if {$command == ""} {return}
	.console.output insert end "% $command\n"	;# TODO: tag showing it's user input
	catch {uplevel 1 $command} result
	.console.output insert end $result\n
	.console.output see end
	lappend ::melonade::console_history $command
	set ::melonade::console_history_index -1
	set command ""
	unset result
}

focus .console.entry

#wm withdraw .console	;# Hidden by default
#wm protocol .console WM_DELETE_WINDOW {wm withdraw .console}	;# Hide rather than close the entire process when the window is closed.

