' Compiles with FreeBasic 1.07.1
' 1: 57
' 2: 193
' 3: 64
' 4: 55
' 5: 35
' 1355323200

' Count trees encountered in a map when going diagonally down.
' Part 2 of day 3 of Advent of Code 2020, see README.txt for details.

' in part 1 we could just scan through the lines while they were being read
' from file, but now it's not that simple. Not that it is impossible to have 
' multiple positions checked in parallel, as they all go down the map, but
' I'm trying my hand at something more generic...

Type toboggan
	x_step as integer
	y_step as integer
	x as integer
	y as integer
	trees as integer
End Type
dim as toboggan sleds(5)
sleds(1) = Type(1,1,1,1,0)
sleds(2) = Type(3,1,1,1,0)
sleds(3) = Type(5,1,1,1,0)
sleds(4) = Type(7,1,1,1,0)
sleds(5) = Type(1,2,1,1,0)


' Check position, add to hit counter
function check_position(byref t as toboggan, terrain() as string, mark as string) as integer
	with t
		var mapline = terrain(.y)
		if(mid(mapline, .x, 1) <> ".") then
			.trees = .trees + 1
			mid(mapline, .x, 1) = mark 'will leave the trail of the last one to hit
		else
			'mid(mapline, .x, 1) = ":"
		end if

		terrain(.y) = mapline
		' Basic counts from 1, which makes the logic 
		' a bit convoluted
		.x = (.x + .x_step - 1) mod len(mapline) + 1
		.y = .y + .y_step
		if .y > ubound(terrain) or .y < 1 then return -1
	end with	
	return 0
end function


redim as string map(any)

var t = timer
const file = "input.txt"
var filehandle = FreeFile()
var mapline = ""

' Load map into dynamic array
if open(file for input as filehandle) = 0 then
	var idx = 1
	do until eof(filehandle)
		line input #filehandle, mapline
		redim preserve map(idx) 'probably not the best way
		map(idx) = mapline
		idx = idx + 1
	loop
else 
	print "Failed to open file " & file
	end
end if


' Run toboggan simulations
dim n as integer
for n = 1 to ubound(sleds)
	do until check_position(sleds(n), map(), chr(64+n) ) : loop 'here you have to have the parentheses for the array...
next
' Output map (just for checking and fun)
for n = 1 to ubound(map)
	print map(n)
next	
' tally the results
var result = 1
for n as integer = 1 to ubound(sleds)
	result = result * sleds(n).trees
	print n & ": " & sleds(n).trees
next
print result

print timer -t & " seconds"