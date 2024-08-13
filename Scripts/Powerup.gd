extends Node

@export var status: String = ""
var possible_status: Array = ["permanent","timer"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func set_status(new_status) -> void:
	if not new_status  in possible_status:
		print("Error: not possible status. Defaulting to timed")
		return
	status = new_status

func get_status():
	return status
