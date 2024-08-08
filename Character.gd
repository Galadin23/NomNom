extends ModularLocation

var char = {
	"speed": 5
}


# Called when the node enters the scene tree for the first time
func _ready():
	pass

# Handle input events
func _input(event):
	if event.is_action_pressed("ui_right"):
		grid_pos.x += 1
	elif event.is_action_pressed("ui_left"):
		grid_pos.x -= 1
	elif event.is_action_pressed("ui_up"):
		grid_pos.y -= 1
	elif event.is_action_pressed("ui_down"):
		grid_pos.y += 1
	
	handle_position()
	

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	# Smoothly interpolate between the current position and the real position
	position = lerp(position, real_pos, char.speed * delta)
