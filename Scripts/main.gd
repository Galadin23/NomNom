extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene
@export var num_obstacles: int = 100 # Total number of obstacles
@export var spawn_interval: float = 1.0 # Time in seconds between each spawn
var obstacle_count = 0
var obstacles: Array = [] # List to hold obstacle instances
var obstacle_queue = []
var large_section = false
#  0 = rock
#  * = Lilypad
#  @ = log
#  - = empty
#  $ = coin
#  
var patterns = [
	#['0-0'],
	#['00-'],
	#['-00'],
	#['--0'],
	#['0--'],
	#[
		#['-*-'],
		#['-*-'],
		#['-*-'],
		#['**-'],
		#['**-'],
		#['*--'],
		#['*--'],
		#['*--'],
	#],
	[
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
	],
]

func queue():
	var pattern_index = randi() % patterns.size() # Choose a random pattern
	var pattern = patterns[pattern_index] # Get the chosen pattern
	# Process each row (y) of the pattern
	for y in range(pattern.size()):
		if pattern.size() == 1:
			obstacle_queue.append(patterns[pattern_index])
		else:
			obstacle_queue.append(pattern[y])


func _ready():
	# Create and add obstacles to the scene
	for i in range(num_obstacles):
		var obstacle_instance = obstacle_scene.instantiate() # Create an instance of the obstacle
		add_child(obstacle_instance) # Add the obstacle to the scene
		obstacles.append(obstacle_instance) # Add the instance to the list


func _on_timer_timeout():
	print(obstacle_queue.size())
	
	$Timer.wait_time = randi() % 5
	if obstacle_queue.size() <=0:
		if large_section == true:
			large_section = false
			return
		queue()

	if obstacle_queue.size() > 1:
		$Timer.wait_time = 0.35
		large_section = true

	var obstacle_course = obstacle_queue.pop_front()
	var row = obstacle_course[0]
	for x in range( row.length()):
		var char = row[x] # Get the character at position x
		if char != '-': # Check if it's not an empty space
			var lane_index = x # Use the x position as the lane index
			obstacles[obstacle_count].choose_lane(lane_index+1) # Set the obstacle to the chosen lane
			obstacles[obstacle_count].enabled = true # Enable the obstacle
			obstacles[obstacle_count].choose_look(char)
			obstacle_count+=1
		if(obstacle_count>=num_obstacles):
			obstacle_count = 0

