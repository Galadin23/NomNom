extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene
@export var collectable_scene: PackedScene # Export the obstacle scene

@onready var player = $Character # Export the obstacle scene
@export var num_obstacles: int = 50 # Total number of obstacles
@export var num_collectables: int = 20 # Total number of obstacles

@export var spacing: int = 300 # Spacing between obstacles

@export var min_empty_space: int = 1 # Minimum number of empty spaces to add
@export var max_empty_space: int = 3 # Maximum number of empty spaces to add

var obstacle_count: int = 0
var collectable_count: int = 0

var obstacles: Array = [] # List to hold obstacle instances
var collectables:Array =[]

var spawn_queue:Array = [] # List to hold the queue of patterns
var start_y_pos: int = 200

#  0 = rock
#  * = Lilypad
#  @ = log

#  - = empty

#  $ = coin
#  % = gem

#  m = magnet
#  s = shield

var patterns: Array = [
	[['-0-']],
	[['00-']],
	[['-00']],
	[['--0']],
	[['0--']],

	[
		['* 0'],
		['* 0'],
		['* 0'],
		['*  '],
		['*  '],
		[' * '],
		[' *0'],
		[' * '],
		[' * '],
		[' * '],
	],
	[
		['***'],
		['***'],
		['***'],
		['***'],
		['***'],
		['***'],
		['***'],
		['***'],
	],
	[
		['   '],
		['0 0'],
		['0  '],
		['00 '],
		['0  '],
		['   '],
		[' 00'],
		[' 00'],
		[' 00'],
		[' 00'],
		[' 00'],
		[' 00'],
		['   '],
	],
]

func _ready():
	# Create and add obstacles to the scene
	for i in range(num_obstacles):
		var obstacle_instance = obstacle_scene.instantiate() # Create an instance of the obstacle
		add_child(obstacle_instance) # Add the obstacle to the scene
		obstacles.append(obstacle_instance) # Add the instance to the list
		
	for i in range(num_collectables):
		var collectable_instance = collectable_scene.instantiate() # Create an instance of the obstacle
		add_child(collectable_instance) # Add the obstacle to the scene
		obstacles.append(collectable_instance) # Add the instance to the list	
	position_objects()

func position_objects() -> void:
	if spawn_queue.size() <=2:
		queue() # Fill the queue with patterns if empty
	
	while spawn_queue.size() > 0:

		var obstacle_course = spawn_queue.pop_front()
		
		for xx in range(obstacle_course.length()):
			var char = obstacle_course[xx] # Get the character at position x
			var lane_index = xx # Use the x position as the lane index
			
			if char != '-' and char != ' ': # Check if it's not an empty space
				if char in Global.game_data.obstacles:
					generate_obstacle(char)
				elif char in Global.game_data.powerups:
					generate_powerups(char)
				elif char in Global.game_data.collectables:
					generate_collectables(char)

		Global.current_y_pos -= spacing

func queue():
	var pattern_index: int = randi() % patterns.size() # Choose a random pattern
	var pattern = patterns[pattern_index] # Get the chosen pattern
	print(pattern.size())
	# Check if the pattern is a single line
	if pattern.size() == 1 and pattern[0].size() == 1:
		var empty_before: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space
		var empty_after: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space

		# Add empty spaces before
		for i in range(empty_before):
			spawn_queue.append('---')
		
		# Add the actual pattern
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				spawn_queue.append(line)
		
		# Add empty spaces after
		for i in range(empty_after):
			spawn_queue.append('---')
	else:
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				spawn_queue.append(line)

func find_screen_height():
	Global.screen_height = get_viewport_rect().size.y
	
func _process(delta):
	if (player.position.y-2000) < Global.current_y_pos:
		position_objects()

func _on_timer_timeout():
	pass

func generate_obstacle(char: String):
	if obstacle_count < num_obstacles:
		obstacles[obstacle_count].position.y = Global.current_y_pos
		obstacles[obstacle_count].choose_lane(lane_index+1) # Set the obstacle to the chosen lane
		obstacles[obstacle_count].enabled = true # Enable the obstacle
		obstacles[obstacle_count].choose_look(char)
		obstacle_count += 1
	if obstacle_count >= num_obstacles-1:
		print("RAN OUT OF OBSTACLES")
		obstacle_count = 0

func generate_powerups(char: String):
	pass

func generate_collectables(char: String):
	if collectable_count < num_collectables:
		collectables[collectable_count].position.y = Global.current_y_pos
		collectables[collectable_count].choose_lane(lane_index+1) # Set the collectable to the chosen lane
		collectables[collectable_count].enabled = true # Enable the collectable
		collectables[collectable_count].setup(char)
		# INSERT FUNCTION TO DETERMINE WHAT COLLECTABLE IT IS
		collectable_count += 1
	if collectable_count >= num_collectables-1:
		print("RAN OUT OF COLLECTABLES")
		collectable_count = 0