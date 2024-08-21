extends Control

var item_button = preload("res://Menus/ItemButton.tscn")
var MARGIN_SIZE: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for shop_item in Global.player_data.shop.keys():
		var item_name = Global.player_data.shop[shop_item]["name"]
		var item_price = Global.player_data.shop[shop_item]["cost"]
		
		var item_btn = item_button.instantiate()
		item_btn.item_name = shop_item
		print(item_btn.name)
		item_btn.get_node("Control/PanelContainer/MarginContainer/InfoHBox/ItemName").text = str(item_name)
		
		if Global.player_data.shop[shop_item]["purchased"]:
			item_btn.get_node("Control/PanelContainer/MarginContainer/InfoHBox/ItemPrice").text = "Owned"
		else:
			item_btn.get_node("Control/PanelContainer/MarginContainer/InfoHBox/ItemPrice").text = str(item_price)
		
		var margin_box = MarginContainer.new()
		margin_box.add_theme_constant_override("margin_top", MARGIN_SIZE)
		margin_box.add_theme_constant_override("margin_left", MARGIN_SIZE)
		margin_box.add_theme_constant_override("margin_bottom", MARGIN_SIZE)
		margin_box.add_theme_constant_override("margin_right", MARGIN_SIZE)
		
		margin_box.add_child(item_btn)
		$ColorRect/VBoxMain/ItemScrollbar/ItemsContainer.add_child(margin_box)
		print(item_btn.item_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect/VBoxMain/TopStats/CoinLabel.text = "Coins: " + str(Global.player_data.coins)
	pass

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
