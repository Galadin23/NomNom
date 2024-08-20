extends Control

var item_button = preload("res://Menus/ItemButton.tscn")
# Adds item to player inventory and subtracts the gold.
func buy_item(item_id):
	# Check if item is valid
	if item_id not in Global.player_data.shop:
		printerr("item does not exist")
		return
	var item = Global.player_data.shop[item_id]
	if item["purchased"]:
		return
	if item["cost"] > Global.player_data.coins:
		print("not enough money")
		return
	else:
		Global.player_data.shop[item_id]["purchased"] = true
		Global.player_data.gold -= item["cost"]
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for shop_item in Global.player_data.shop.keys():
		var item_name = Global.player_data.shop[shop_item]["name"]
		#var item_btn = Label.new()
		#item_btn.text = item_name
		var item_btn = item_button.instantiate()
		item_btn.name = item_name
		print(item_btn.position)
		$ColorRect/VBoxMain/ItemScrollbar/ItemsContainer.add_child(item_btn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect/VBoxMain/TopStats/CoinLabel.text = "Coins: " + str(Global.player_data.coins)
	pass

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("item clicked")

