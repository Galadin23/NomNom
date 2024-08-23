extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene
@export var collectable_scene: PackedScene # Export the obstacle scene
@export var powerup_scene: PackedScene # Export the obstacle scene

@onready var player = $Player/Character # Export the obstacle scene
@onready var above_water = $AboveWater

@export var num_obstacles: int = 50 # Total number of obstacles
@export var num_collectables: int = 50 # Total number of collectables
@export var num_powerups: int = 10 # Total number of powerups

@export var spacing: int = 300 # Spacing between obstacles

@export var min_empty_space: int = 1 # Minimum number of empty spaces to add
@export var max_empty_space: int = 3 # Maximum number of empty spaces to add

var obstacle_count: int = 0  # What obstacle is selected
var collectable_count: int = 0 # What collectable is selected
var powerup_count: int = 0 # What powerup is selected

var obstacles: Array = [] # List to hold obstacle instances
var collectables:Array =[] # List to hold collectable instances
var powerups: Array = [] # List to hold powerup instances

var spawn_queue:Array = [] # List to hold the queue of patterns
var start_y_pos: int = 200

#  0 = rock
#  * = Lilypad
#  @ = log

#  - = empty

#  $ = coin
#  % = gem

#  ^ = brocolii
#  + = burger


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

	[
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
	],
	[
		['$$$'],
		['$$$'],
		['$$$'],
		['$$$'],
		['$$$'],
		['$$$'],
		['$$$'],
	],
	[
		[' $ '],
		[' $ '],
		['-$-'],
		['-$-'],
		[' $ '],
		[' $ '],
		['-$-'],
		['-$-'],
		[' $ '],
		[' $ '],
		['-$-'],
		['-$-'],
		[' $ '],
		[' $ '],
	],
	[
		['---'],
		['$$$'],
		['-$-'],
		['$$$'],
		['-$-'],
		['$$$'],
		['-$-'],
		['$$$'],
		['---'],
	],
	[
		['$$$'],
		['-$-'],
		['-$-'],
		['$$$'],
		['-$-'],
		['$$$'],
		['-$-'],
		['-$-'],
		['$$$'],
	],
	[
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
		['$$-'],
	],
	[
		['---'],
		['-$-'],
		['$$$'],
		['$$$'],
		['$$$'],
		['$$$'],
		['-$-'],
		['-$-'],
		['$$$'],
	],
	[
		['$$$'],
		['$$-'],
		['-$-'],
		['-$-'],
		['$$-'],
		['$$$'],
		['-$-'],
		['-$-'],
		['$$-'],
		['$$$'],
	],
	[
		[' $ '],
		[' $ '],
		[' $ '],
		['-$-'],
		['-$-'],
		[' $ '],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		[' $ '],
	],
	[
		['$$$'],
		[' $ '],
		[' $ '],
		['-$-'],
		['-$-'],
		['$$$'],
		['$$$'],
		[' $ '],
		['-$-'],
		['-$-'],
	],

	# New coin and rock big course patterns
	[
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
	],
	[
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
		['0-$'],
	],
	[
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
		['-$0'],
	],
	[
		['-$-'],
		['0-$'],
		['0$0'],
		['-$0'],
		['0-$'],
		['0$0'],
		['-$0'],
		['0-$'],
		['0$0'],
		['-$0'],
		['0-$'],
	],
	[
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['-$-'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
		['0$0'],
	],
	[
		['0$$'],
		['0$$'],
		['0$$'],
		['0$$'],
		['0$$'],
		['0$$'],
		['0$$'],
	],
	[
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
		['$$0'],
	],
	[
		['$$$'],
		['0$$'],
		['0$0'],
		['$$0'],
		['0$$'],
		['0$0'],
		['$$0'],
		['0$$'],
		['0$0'],
		['$$0'],
		['0$$'],
		['0$0'],
	],
	[
		['-$0'],
		['0$$'],
		['-$-'],
		['-$0'],
		['-$0'],
		['-$-'],
		['0$$'],
		['0$0'],
		['-$0'],
		['0$0'],
		['-$-'],
		['-$0'],
	],
	[
		['$$$'],
		['$$-'],
		['0$$'],
		['-$0'],
		['0$0'],
		['$$$'],
		['$$0'],
		['$$-'],
		['0$$'],
		['-$0'],
	],
	[
		['0$$'],
		['-$-'],
		['-$-'],
		['-$0'],
		['0$$'],
		['-$-'],
		['$$$'],
		['$$0'],
		['-$0'],
		['$$$'],
	],

]
var in_between_coins = [
	['-$-'],
	['$$$'],
	['-$-'],
	['$--'],
	['-$-'],
	['$$-'],
	['-$-'],
	['--$'],
	['$$$'],
	['$--'],
	['-$-'],
	[' $ '],
	['--$'],
	['--$'],
	['--$'],
	['-$-'],
	['$--'],
	['$--'],
]

func _ready():
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
					generate_obstacle(char, lane_index)
				elif char in Global.game_data.powerups:
					pass
					#generate_powerups(char, lane_index)
				elif char in Global.game_data.collectables:
					pass
					generate_collectables(char, lane_index)

		Global.current_y_pos -= spacing

func handle_empty(empty_size):
	for i in range(empty_size):
		if randi() % 2 == 0:  # 50% chance to add in-between coins instead of blank space
			for j in range(i):
				var coin_index: int = randi() % in_between_coins.size()
				spawn_queue.append(in_between_coins[coin_index][0])
		else:
			spawn_queue.append('---')


func queue():
	var pattern_index: int = randi() % patterns.size() # Choose a random pattern
	var pattern = patterns[pattern_index] # Get the chosen pattern
	print(pattern.size())
	# Check if the pattern is a single line
	if pattern.size() == 1 and pattern[0].size() == 1:
		var empty_before: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space
		var empty_after: int = randi() % (max_empty_space - min_empty_space + 1) + min_empty_space

		# Add empty spaces before
		handle_empty(empty_before)
		
		# Add the actual pattern
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				spawn_queue.append(line)
		
		# Add empty spaces or in-between coins after
		handle_empty(empty_after)
		
	else:
		for row in range(pattern.size() - 1, -1, -1):
			for line in pattern[row]:
				spawn_queue.append(line)

func find_screen_height():
	Global.screen_height = get_viewport_rect().size.y
	
func _process(delta):
	if (player.position.y-2000) < Global.current_y_pos:
		position_objects()



func generate_obstacle(char: String, lane_index: int):
	var new_obstacle = obstacle_scene.instantiate() # Create an instance of the obstacle
	new_obstacle.position.y = Global.current_y_pos
	new_obstacle.char = char
	new_obstacle.choose_lane(lane_index+1) # Set the obstacle to the chosen lane
	above_water.add_child(new_obstacle) # Add the obstacle to the scene

func generate_powerups(char: String, lane_index: int):
	var new_powerup = powerup_scene.instantiate() # Create an instance of the obstacle
	new_powerup.position.y = Global.current_y_pos
	powerups[powerup_count].powerup_preset(char)
	new_powerup.choose_lane(lane_index+1) # Set the obstacle to the chosen lane
	above_water.add_child(new_powerup) # Add the obstacle to the scene

	# if powerup_count < num_powerups:
	# 	powerups[powerup_count].position.y = Global.current_y_pos
	# 	powerups[powerup_count].choose_lane(lane_index+1) # Set the collectable to the chosen lane
	# 	powerups[powerup_count].powerup_preset(char)
	# 	powerup_count += 1
	# if powerup_count >= num_powerups-1:
	# 	print("RAN OUT OF POWERUPS")
	# 	powerup_count = 0


func generate_collectables(char: String, lane_index: int):
	var new_collectable = collectable_scene.instantiate() # Create an instance of the obstacle
	new_collectable.position.y = Global.current_y_pos
	new_collectable.char = char
	new_collectable.choose_lane(lane_index+1) # Set the obstacle to the chosen lane
	above_water.add_child(new_collectable) # Add the obstacle to the scene
	