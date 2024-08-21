extends ModularLocation

var lanes: int = 0
var move_speed = 800.0 # Speed of movement downwards
var current_lane = 0
var dangerous = false
var obstacle_height = []
var will_be_destroyed = false
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
	if char == "0":
		obstacle_height = [0,1,2]
		dangerous = true
	elif char == "*":
		obstacle_height = [1]

func remove():
	enabled = false
	dangerous = false
	will_be_destroyed = false
	position.y = 3000

func _on_area_2d_body_entered(body):
	if dangerous == false and body.get_parent().heightlayer == 0:
		will_be_destroyed = true
	if dangerous == false and body.get_parent().heightlayer == 1 and will_be_destroyed == true:
		remove()
	if dangerous and body.get_parent().heightlayer in obstacle_height:
		Global.take_damage()
		remove()
