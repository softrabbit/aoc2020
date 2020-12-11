' Compiles with FreeBasic 1.07.1

' Count trees encountered in a map when going diagonally down.
' Part 1 of day 3 of Advent of Code 2020, see README.txt for details.

var t = timer
const file = "input.txt"
const move_right = 3
const move_down = 1

var trees = 0
var filehandle = FreeFile()
var mapline = ""
var pos_x = 1
var pos_y = 1

'if open(file for input as filehandle) returns true on failure(!)
if open(file for input as filehandle) = 0 then
	do until eof(filehandle)
		line input #filehandle, mapline
		if(mid(mapline, pos_x, 1) = "#") then
			trees = trees + 1
			mid(mapline, pos_x, 1) = "X"
		else
			mid(mapline, pos_x, 1) = "x"
		end if
		print mapline
		' Basic counts from 1, which makes the logic 
		' a bit convoluted
		pos_x = (pos_x + move_right - 1) mod len(mapline) + 1
	loop
else 
	print "Failed to open file " & file
end if

print trees & " trees hit"
print timer -t & " seconds"