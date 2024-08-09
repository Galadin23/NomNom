extends ModularLocation


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position,real_pos,5*delta)


func _on_area_2d_body_entered(body):
	print("Coin Collected")
