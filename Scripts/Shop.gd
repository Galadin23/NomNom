extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	for shop_item in Global.player_data.shop.keys():
		var item_btn = Label.new()
		item_btn.text = "hello world"
		$ColorRect/VBoxMain/ItemScrollbar/ItemsContainer.add_child(item_btn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect/VBoxMain/TopStats/CoinLabel.text = "Coins: " + str(Global.player_data.coins)
	pass

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
