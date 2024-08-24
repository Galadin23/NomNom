extends ModularLocation

@export var collectable_name: String = ""
@export var collection_type: String = ""
@onready var collectable_image: AnimationPlayer = $AnimationPlayer
var char = ""

func _ready():
	call_deferred("setup")

func setup():
	match char:
		"$": # Money
			collectable_name = "coin"
			collection_type = "coins"
		"%": # Gem
			collectable_name = "gem"
			collection_type = "gems"
		"^": # broccoli
			collectable_name = "broccoli"
			collection_type = "food"		
		"+": # burger
			collectable_name = "burger"
			collection_type = "food"	
	handle_image()	

func handle_collection():
	match collection_type:
		"food":
			Global.game_data.health += Global.food.collectable_name.health
			Global.game_data.energy += Global.food.collectable_name.energy
			Global.apply_food(Global.food.collectable_name.health,Global.food.collectable_name.energy)
		"coins":
			Global.collect_money("coin", 1)
		"gems":
			Global.collect_money("gem", 1)			

func handle_image():
	collectable_image.play(collectable_name)


func _on_area_2d_body_entered(body):
	handle_collection()
	queue_free()
