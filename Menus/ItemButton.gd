extends Node2D

var item_name: String = ""

# validates purchases made through buttons
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
		Global.purchase_item(self.item_name)
		print(self.item_name + " purchased for " + str(item["cost"]))
		$Control/PanelContainer/MarginContainer/InfoHBox/ItemPrice.text = "Owned"
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			buy_item(self.item_name)

