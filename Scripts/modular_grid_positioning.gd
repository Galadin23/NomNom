extends Node2D

class_name ModularLocation

var grid_pos = [0,0]
var real_pos = Vector2.ZERO
var grid_size = [3,10]
var screen_size = [1080, 1920]
var lanes: int = 0
var current_lane = 0


func choose_lane(lane):
	lanes = grid_size[0]
	if lane > lanes:
		current_lane = randi() % lanes +1
	else: 
		current_lane = lane
	grid_pos[0] = current_lane
	handle_position()
	position.x = real_pos.x

func handle_position():
	screen_size[1] = Global.screen_height
	#print(grid_pos)
	# Clamp position within grid bounds
	grid_pos[0] = clamp(grid_pos[0], 1, grid_size[0])
	grid_pos[1] = clamp(grid_pos[1], 1, grid_size[1])
	

	# Calculate real position and update node's position
	real_pos.x = grid_pos[0] * (screen_size[0] / (grid_size[0]+1 ))
	real_pos.y = grid_pos[1] * ((screen_size[1] / (grid_size[1] +1) ))
