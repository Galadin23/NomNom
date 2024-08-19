extends ModularLocation
@onready var state_chart:StateChart = $StateChart
@onready var anim: AnimationPlayer = $CharacterBody2D/AnimationPlayer
@onready var chara: Dictionary = {
	"jump_power":230,
	"gravity": 980,
	"move_speed": 800,
}
var Applied_powerups: Array = [] # what powerups are applied to the player during the game

var heightlayer: int = 1 # 0 = underwater 1 = water, 2 = lilipad
var Ypos: int = 0;
var char_velocity = 0
var airborn: bool = false
var swipe: Dictionary = {
	"length": 60,
	"swiping": false,
	"startPos": Vector2.ZERO,
	"curPos": Vector2.ZERO,
	"swipe_x": [false,false],
	"swipe_y": [false,false],
	"threshold": 20,
}



# Called when the node enters the scene tree for the first time
func _ready():
	grid_pos = [2,11]
	handle_position()
	position = real_pos


# Handle input events
func _input(event):

	if event.is_action_pressed("ui_right"):
		grid_pos[0] += 1
	elif event.is_action_pressed("ui_left"):
		grid_pos[0] -= 1
	#elif event.is_action_pressed("ui_up"):
		#grid_pos[1] -= 1
	#elif event.is_action_pressed("ui_down"):
		#grid_pos[1] += 1
	if event.is_action_pressed("z") and not airborn:
		print("Z pressed")
		state_chart.send_event('Diving')
	if event.is_action_pressed("space_bar"):
		state_chart.send_event('Jumping')

	handle_position()


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	if Global.
	#print(Global.traits['magnet_enabled'])
	if Ypos <=0 and airborn:
		airborn = false
		state_chart.send_event('Swimming')

	# Smoothly interpolate between the current position and the real position
	#position = lerp(position, real_pos, chara.speed * delta)
	position.x = lerp(position.x, real_pos.x, Global.traits["speed"] * delta)
	swipe_handling()
	move_object(delta)

func swipe_handling():
	if Input.is_action_just_released("press"):
		swipe.swiping = false
		swipe.swipe_x = [false,false]
		swipe.swipe_y = [false, false]

	if Input.is_action_just_pressed("press"):
		if !swipe.swiping:
			swipe.swiping = true
			swipe.startPos = get_global_mouse_position()

	if swipe.swiping:
		swipe.curPos = get_global_mouse_position()
		if swipe.startPos.distance_to(swipe.curPos)>swipe.length:
			if abs(swipe.startPos.y-swipe.curPos.y) <= swipe.threshold*3: # Horizontal Swiping
				if swipe.startPos.x < swipe.curPos.x and not swipe.swipe_x[0]: # Going Right
					swipe.swipe_x[0] = true
					swipe.swipe_x[1] = false
					grid_pos[0] += 1
				elif swipe.startPos.x > swipe.curPos.x and not swipe.swipe_x[1]: # Going Left
					swipe.swipe_x[0] = false
					swipe.swipe_x[1] = true
					grid_pos[0] -= 1
			#if abs(swipe.startPos.x-swipe.curPos.x) <= swipe.threshold*7: # Horizontal Swiping
				#if swipe.startPos.y+100 < swipe.curPos.y and not swipe.swipe_y[0]: # Going Right
					#swipe.swipe_y[0] = true
					#swipe.swipe_y[1] = false
					#grid_pos[1] += 1
				#elif swipe.startPos.y-100 > swipe.curPos.y and not swipe.swipe_y[1]: # Going Left
					#swipe.swipe_y[0] = false
					#swipe.swipe_y[1] = true
					#grid_pos[1] -= 1


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


func move_object(delta):
	position.y -= chara.move_speed * delta

func take_damage():

	pass
