extends Sprite

const BLOCK_FLOOR = 0
const BLOCK_FREE = 1
const BLOCK_OCCUPIED = 2
# Declare member variables here. Examples:
var state
var textures = [preload("res://wall.png"), preload("res://seat_green.png"), preload("res://seat_red.png")]	
var neighbors = []
var pending_update = false
var next_state = BLOCK_FLOOR
var free_limit # This is set from outside to control game rule for freeing occupied seats

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass

func _on_update():
	if pending_update == false:		
		var sum = 0
		next_state = state
		for n in neighbors:
			if n.state == BLOCK_OCCUPIED:
				sum += 1 
		if state == BLOCK_FREE and sum == 0:
			next_state = BLOCK_OCCUPIED
		if state == BLOCK_OCCUPIED and sum >=free_limit: 
			next_state = BLOCK_FREE		
		pending_update = true
		
# Commit the new state
func _on_commit():
	if pending_update == true:
		change_state(next_state)
		pending_update = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Can't have the original active, only the copies
func activate():
	get_parent().connect("update", self, "_on_update")
	get_parent().connect("commit", self, "_on_commit")

func change_state(newstate):	
	set_texture(textures[newstate])
	state = newstate

