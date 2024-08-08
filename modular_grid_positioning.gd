extends Node2D

class_name ModularLocation

var grid_pos = Vector2.ZERO
var real_pos = Vector2.ZERO
var grid_size = Vector2(3, 10)
var screen_size = Vector2(1080, 1920)

func handle_position():
	print(grid_pos)
	# Clamp position within grid bounds
	grid_pos.x = clamp(grid_pos.x, 1, grid_size.x) 
	grid_pos.y = clamp(grid_pos.y, 1, grid_size.y) 
	

	# Calculate real position and update node's position
	real_pos.x = grid_pos.x * (screen_size.x / (grid_size.x+1 ))
	real_pos.y = grid_pos.y * ((screen_size.y / grid_size.y +1 ))
