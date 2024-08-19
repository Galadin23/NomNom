extends ModularLocation

@export var collectable_name: String = ""
@export var collection_type: String = ""
@onready var collectable_image: AnimationPlayer = $AnimationPlayer

func handle_collection():
	match collection_type:
		"food":
			Global.game_data.health += Global.food.collectable_name.health
			Global.game_data.energy += Global.food.collectable_name.energy

func handle_image():
	collectable_image.play(collectable_name)


func _on_area_2d_body_entered(body):
	handle_collection()
