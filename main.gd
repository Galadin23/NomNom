extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene
@export var num_obstacles: int = 100 # Total number of obstacles
@export var spawn_interval: float = 1.0 # Time in seconds between each spawn

var obstacles: Array = [] # List to hold obstacle instances
#0 = rock
#* = Lilypad
#@ = log
#- = empty

var patterns = [
	['0-0'],
	['00-'],
	['-00'],
	['--0'],
	['0--'],
	[
	'0-0',
	'0--',
	'00-',
	'00-',
	'---',
	'-00',
	]
]


func _ready():
	# Create and add obstacles to the scene
	for i in range(num_obstacles):
		var obstacle_instance = obstacle_scene.instantiate() # Create an instance of the obstacle
		add_child(obstacle_instance) # Add the obstacle to the scene
		obstacles.append(obstacle_instance) # Add the instance to the list
	
func _on_timer_timeout():
	var count = 0
	for obstacle in obstacles:
		if not obstacle.enabled and count < 3:
			obstacle.enabled = true # Enable the obstacle
			count += 1
		if count >= 3:
			break


