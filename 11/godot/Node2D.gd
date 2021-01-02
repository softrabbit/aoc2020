extends Node2D

# Game of Life -ish waiting room seating simulation. 
# ~9000 sprites commanded through signals.
# The number we're looking for comes in the debug output for now.

# Select full input or smaller set (expected to settle at 37 or 26)
const full_input = true
# Select part 1 or part 2 algorithm 
# (all 8 adjacent are neighbours or line-of-sight to next seat, also
# affects the rule for freeing seats)
const puzzle_part = 1
####################################################

var map
signal update
signal commit
var updatetime = 0
var update_requested
var seatmap = []


# First part neighbor finder, neighbors are in the adjacent positions
# but we can safely ignore floor tiles.
func find_neighbors1(r,c):
	var n = []
	# Let's hope all rows are of equal length.
	# These are offsets to scan the nearby cells
	var xs = [-1,0,1]
	var ys = [-1,0,1]
	if r == 0: # first row has none above
		ys = [0,1]
	if r == seatmap.size()-1: # last row has none below
		ys = [-1,0]
	if c == 0: # ...and the same for columns
		xs = [0,1]
	if c == seatmap[r].size()-1:
		xs = [-1,0]
	for x in xs:
		for y in ys:
			# Don't append the sprite itself, and floor can be ignored
			if not (x==0 and y==0) and seatmap[r+y][c+x].state!=seatmap[0][0].BLOCK_FLOOR:
				n.append(seatmap[r+y][c+x]) # Row first, column second
	return n
	
# in part 2 neighbors are the next chairs in all 8 directions
# (i.e. skipping over floor tiles)
func find_neighbors2(r,c):
	var n = []
	var x
	var y
	# We can ignore this looping for floor cells, they never turn into chairs
	if seatmap[r][c].state != seatmap[0][0].BLOCK_FLOOR:
		for ri in [-1,0,1]: # row and col increments
			for ci in [-1,0,1]:			
				if not (ri == 0 and ci == 0):
					x = c +ci
					y = r +ri
					while x>=0 and y>=0 and y<seatmap.size() and x<seatmap[y].size() and seatmap[y][x].state == seatmap[0][0].BLOCK_FLOOR:
						x += ci
						y += ri
					if x>=0 and y>=0 and y<seatmap.size()and x<seatmap[y].size():
						n.append(seatmap[y][x])
						
	return n
		
func _process(delta):
	updatetime += delta
	if updatetime > .5:
		var commitable = true
		var seats_occupied = 0
		# Check if all seats have their update_pending flag set
		for r in range(0,seatmap.size()):
			for c in range(0,seatmap[r].size()):
				commitable = commitable && seatmap[r][c].pending_update
				if seatmap[r][c].state == $Block.BLOCK_OCCUPIED:
					seats_occupied +=  1
		if commitable:
			emit_signal("commit")	
			updatetime = 0			
			update_requested = false
			print("Commit %s" % seats_occupied)
	if updatetime > .2 and update_requested==false:		
		emit_signal("update")
		update_requested = true
		print("Update...")
	
func _init():
	
	var block = preload("Block.gd")
	
	# Load grid from file
	var inp = File.new()
	if full_input:
		inp.open("res://input.txt", File.READ)
	else:
		inp.open("res://small.txt", File.READ)
		
	var row=0
	var data = inp.get_line()
	
	while data != "":
		var seatrow = []
		var col = 0
		for c in data:
			var s = block.new()
			s.apply_scale(Vector2(.25,.25))
			s.position.x = col *16
			s.position.y = row *16
			if c == 'L':
				s.change_state(block.BLOCK_FREE)
			if c == '#':
				s.change_state(block.BLOCK_OCCUPIED)
			if c == '.':
				s.change_state(block.BLOCK_FLOOR)
			seatrow.append(s)			
			add_child(s)
			if puzzle_part == 1:
				s.free_limit = 4
			if puzzle_part == 2:
				s.free_limit = 5
			s.activate()
			col += 1
			
		data = inp.get_line()
		row += 1
		seatmap.append(seatrow)
		
	# Set up neighbors for each cell
	for r in range(0,seatmap.size()):
		for c in range(0,seatmap[r].size()):
			if puzzle_part == 1:
				seatmap[r][c].neighbors = find_neighbors1(r,c)
			else:
				seatmap[r][c].neighbors = find_neighbors2(r,c)
				
	update_requested = false			
	print("%s x %s" % [seatmap.size(), seatmap[0].size()])
	

