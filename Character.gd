extends Node2D

# Define variables with default values
var grid_pos = Vector2.ZERO
var real_pos = Vector2.ZERO
var grid_size = Vector2(4, 11)
var screen_size = Vector2(1080, 1920)

var move_speed = 50 # Adjust this value to control the transition speed
var smooth_speed = 5 # Adjust this value to control the smoothness


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
	
	# Clamp position within grid bounds
	grid_pos.x = clamp(grid_pos.x, 1, grid_size.x - 1)
	grid_pos.y = clamp(grid_pos.y, 1, grid_size.y - 1)
	print(grid_pos)
	
	# Calculate real position and update node's position
	real_pos.x = grid_pos.x * (screen_size.x / grid_size.x)
	real_pos.y = grid_pos.y * (screen_size.y / grid_size.y)
	

# Called every frame. 'delta' is the elapsed time since the previous frame
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	# Smoothly interpolate between the current position and the real position
	position = lerp(position, real_pos, smooth_speed * delta)
