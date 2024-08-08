extends Node2D

@export var obstacle_scene: PackedScene # Export the obstacle scene

# Called when the node enters the scene tree for the first time.

func _on_timer_timeout():
	var obstacle_instance = obstacle_scene.instantiate() # Create an instance of the obstacle
	add_child(obstacle_instance) # Add the obstacle to the scene
	# Position the obstacle randomly or in a grid
	obstacle_instance.position = Vector2(randf() * get_viewport().size.x, -200)
