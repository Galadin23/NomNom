extends ModularLocation

var lanes: int = 0
var move_speed = 400.0 # Speed of movement downwards
var current_lane = 0
var start_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time
func _ready():
	lanes = grid_size.x
	# Choose a random lane and set the initial position
	current_lane = randi() % lanes +1
	grid_pos.x = current_lane
	handle_position()
	start_position = Vector2(real_pos.x, -200) # Start position off-screen
	position = start_position

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	# Move the obstacle downwards
	position.y += move_speed * delta
	
	# Optionally, reset the position when it goes off-screen
	if position.y > get_viewport().size.y:
		current_lane = randi() % lanes +1
		grid_pos.x = current_lane
		handle_position()
		position.x = real_pos.x
		position.y = -200
