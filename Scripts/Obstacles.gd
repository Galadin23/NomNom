extends ModularLocation


var move_speed = 800.0 # Speed of movement downwards

var dangerous = false
var obstacle_height = []
var will_be_destroyed = false
var char = ""
@onready var player = $AnimationPlayer
@onready var enabled = false

# Called when the node enters the scene tree for the first time
func _ready():
	call_deferred("do_setup")


	
func do_setup():
	enabled = true
	choose_look(char)

	
func choose_look(char:String):
	player.play(char)
	if char == "0":
		obstacle_height = [0,1,2]
		dangerous = true
	elif char == "*":
		obstacle_height = [1]

func remove():
	queue_free()
	enabled = false
	dangerous = false
	will_be_destroyed = false
	
	#position.y = 3000

func _on_area_2d_body_entered(body):
	if dangerous == false and body.get_parent().heightlayer == 0:
		will_be_destroyed = true
	if dangerous == false and body.get_parent().heightlayer == 1 and will_be_destroyed == true:
		remove()
	if dangerous and body.get_parent().heightlayer in obstacle_height:
		Global.take_damage()
		remove()
