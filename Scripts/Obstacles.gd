extends ModularLocation

var lanes: int = 0
var move_speed = 800.0 # Speed of movement downwards
var current_lane = 0
@onready var player = $AnimationPlayer
@onready var enabled = false

# Called when the node enters the scene tree for the first time
func _ready():
	call_deferred("do_setup")
	position.y = 20000

func choose_lane(lane):
	lanes = grid_size[0]
	if lane > lanes:
		current_lane = randi() % lanes +1
	else: 
		current_lane = lane
	grid_pos[0] = current_lane
	handle_position()
	position.x = real_pos.x
	
func do_setup():
	enabled = false

	
func choose_look(char:String):
	player.play(char)




# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	# Smoothly interpolate between the current position and the real position
	#position = lerp(position, real_pos, 5 * delta)
	position.x = real_pos.x
	pass
