extends ModularLocation

var char = {
	"speed": 10,
	"jump_power":230,
	"dive_length":2, 
	"gravity": 980,
}


@onready var state_chart:StateChart = $StateChart
@onready var anim: AnimationPlayer = $CharacterBody2D/AnimationPlayer
var heightlayer: int = 1 # 0 = underwater 1 = water, 2 = lilipad
var Ypos = 0;
var char_velocity = 0
var airborn = false

# Called when the node enters the scene tree for the first time
func _ready():
	pass

# Handle input events
func _input(event):

	if event.is_action_pressed("ui_right"):
		grid_pos[0] += 1
	elif event.is_action_pressed("ui_left"):
		grid_pos[0] -= 1
	elif event.is_action_pressed("ui_up"):
		grid_pos[1] -= 1
	elif event.is_action_pressed("ui_down"):
		grid_pos[1] += 1
	if event.is_action_pressed("z") and not airborn:
		print("Z pressed")
		state_chart.send_event('Diving')
	if event.is_action_pressed("space_bar"):
		state_chart.send_event('Jumping')
		
	handle_position()
	

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	if Ypos <=0 and airborn:
		airborn = false
		state_chart.send_event('Swimming')
	# Smoothly interpolate between the current position and the real position
	position = lerp(position, real_pos, char.speed * delta)


func _on_jumping_state_entered():
	airborn = true
	heightlayer +=1
	Ypos = 20
	anim.play("jumping")


func _on_diving_state_entered():
	heightlayer = 0
	$divetimer.start()


func _on_swimming_state_entered():
	heightlayer = 1
	anim.play("swimming")


func _on_running_state_entered():
	heightlayer = 2
	anim.play("running")


func _on_divetimer_timeout():
	state_chart.send_event('Swimming')
