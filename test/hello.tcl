puts "Hello, World - In quotes"    ;# This is a comment after the command.
# This is a comment at beginning of a line
puts {Hello, World - In Braces}

puts "This is line 1"; puts "this is line 2"

puts "Hello, World; - With  a semicolon inside the quotes"

# Words don't need to be quoted unless they contain white space:
puts HelloWorld

##################################
set X "This is a string"

set Y 1.24

puts $X
puts $Y

puts "..............................."

set label "The value in Y is: "
puts "$label $Y"

####################################

set x 1

# This is a normal way to write a Tcl while loop.

while {$x < 5} {
    puts "x is $x"
    set x [expr {$x + 1}]
}

puts "exited first loop with X equal to $x\n"

# The next example shows the difference between ".." and {...}
# How many times does the following loop run?  Why does it not
# print on each pass?

set x 0
while "$x < 5" {
    set x [expr {$x + 1}]
    if {$x > 7} break
    if "$x > 3" continue
    puts "x is $x"
}

puts "exited second loop with X equal to $x"
