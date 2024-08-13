extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene
@export var num_obstacles: int = 100 # Total number of obstacles
@export var spacing: int = 300 # Spacing between obstacles
@export var min_empty_space: int = 1 # Minimum number of empty spaces to add
@export var max_empty_space: int = 3 # Maximum number of empty spaces to add

var obstacle_count: int = 0
var obstacles: Array = [] # List to hold obstacle instances
var obstacle_queue:Array = []
var start_y_pos: int = 200


var patterns: Array = [
	[['-0-']],
	[['00-']],
	[['-00']],
	[['--0']],
	[['0--']],
	[
		['-*-'],
		['-*-'],
		['-*-'],
		['**-'],
		['**-'],
		['*--'],
		['*--'],
		['*--'],
	],
	[
		['---'],
		['0-0'],
		['0--'],
		['00-'],
		['0--'],
		['---'],
		['-00'],
		['-00'],
		['-00'],
		['-00'],
		['-00'],
		['-00'],
		['---'],
	],
]

func _ready():
	# Create and add obstacles to the scene
	for i in range(num_obstacles):
		var obstacle_instance = obstacle_scene.instantiate() # Create an instance of the obstacle
		add_child(obstacle_instance) # Add the obstacle to the scene
		obstacles.append(obstacle_instance) # Add the instance to the list
	
	position_obstacles()

func position_obstacles() -> void:
	var current_y_pos:int = start_y_pos
	var pattern_index: int = 0
	
	while pattern_index < num_obstacles:
		if obstacle_queue.size() <=2:
			queue() # Fill the queue with patterns if empty
		
		var obstacle_course = obstacle_queue.pop_front()

		for xx in range(obstacle_course.length()):
			var char = obstacle_course[xx] # Get the character at position x
			var lane_index = xx # Use the x position as the lane index

			if char != '-': # Check if it's not an empty space
				if obstacle_count < num_obstacles:
					obstacles[obstacle_count].position.y = current_y_pos
					obstacles[obstacle_count].choose_lane(lane_index+1) # Set the obstacle to the chosen lane
					obstacles[obstacle_count].enabled = true # Enable the obstacle
					obstacles[obstacle_count].choose_look(char)
					obstacle_count += 1
			if obstacle_count >= num_obstacles:
				return
		current_y_pos -= spacing
		pattern_index += 1

func queue():
	var pattern_index: int = randi() % patterns.size() # Choose a random pattern
	var pattern = patterns[pattern_index] # Get the chosen pattern
	
	# Check if the pattern is a single line
	if pattern.size() == 1 and pattern[0].size() == 1:
		var empty_before: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space
		var empty_after: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space

		# Add empty spaces before
		for i in range(empty_before):
			obstacle_queue.append('---')
		
		# Add the actual pattern
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				obstacle_queue.append(line)
		
		# Add empty spaces after
		for i in range(empty_after):
			obstacle_queue.append('---')
	else:
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				obstacle_queue.append(line)

func find_screen_height():
	Global.screen_height = get_viewport_rect().size.y
