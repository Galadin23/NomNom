extends Node2D

class_name ModularLocation

@onready var grid_pos = [0,0]
@onready var real_pos = Vector2.ZERO
@onready var grid_size = [3,10]
var screen_size = [1080, 1920]

func handle_position():
	print(grid_pos)
	# Clamp position within grid bounds
	grid_pos[0] = clamp(grid_pos[0], 1, grid_size[0])
	grid_pos[1] = clamp(grid_pos[1], 1, grid_size[1])
	

	# Calculate real position and update node's position
	real_pos.x = grid_pos[0] * (screen_size[0] / (grid_size[0]+1 ))
	real_pos.y = grid_pos[1] * ((screen_size[1] / grid_size[1] +1 ))
