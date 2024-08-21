extends Node

const SAVE_DIR: String = "user://saves/"
const SAVE_FILE_NAME: String = "save.json"
const SECURITY_KEY: String = "089SADFH"

var screen_height: int = 1920

var player_data: PlayerData = PlayerData.new()
var traits: Dictionary = {} # Traits used for upgrades in-game
var player_traits_default: Dictionary = {} # used for a reference for in-game traits to use
var upgrades: Array = [] # The powerups, and upgrades for the player in-game
var current_y_pos:int = 0

var game_data: Dictionary = {
	"lives": 1,
	"shield": 0,
	"health": 0,
	"energy": 0,
	"obstacles": ["*","0"],
	"powerups": ["m","s"],
	"collectables": ["$","%"],
}

var food: Dictionary = {
	"broccoli": {"energy": 10, "health": 5 },
	"fries": {"energy": 15, "health": -10 },
	"burger": {"energy": 20, "health": -15 },
	"fruit_bowl": {"energy": 20, "health": 15 },
	"golden_apple": {"energy": 50, "health": 50 },
}


func _ready():
	verify_save_directory(SAVE_DIR)
	load_data(SAVE_DIR)
	
	if traits.is_empty():
		player_data = PlayerData.new()
		player_traits_default = player_data.traits
		traits = player_data.traits
		if player_traits_default.is_empty() or traits.is_empty():
			print("ERROR: default traits or traits is empty")
		
		save_data(SAVE_DIR)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save_data(path: String) -> void:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE,SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data: Dictionary = {
		"player_data": {
			"coins": player_data.coins,
			"gems": player_data.gems,
			"shop": player_data.shop,
			"statistics": player_data.statistics,
			"traits": player_data.traits,
		}
	}
	
	var json_string: String = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
	
func load_data(path:String) -> void:
	if FileAccess.file_exists(path):
		var file: FileAccess = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content: String = file.get_as_text()
		file.close
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("cannot parse %s as a json_string: (%s)" % [path, content])
			return
		player_data = PlayerData.new()
		player_data.coins = data.player_data.health
		player_data.gems = data.player_data.gems
		player_data.shop = data.player_data.shop
		player_data.statistics = data.player_data.statistics
		player_data.traits = data.player_data.traits
		player_traits_default = data.player_data.traits
		
	else:
		printerr("Cannot open non-existent file at %s!" % [path])

func apply_upgrades():
	# Restore default traits
	traits = player_traits_default.duplicate()
	
	for upgrade in upgrades:
		apply_upgrade(upgrade)

func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var attribute: String = upgrade.attribute_name
	var value: float = upgrade.effect_value
	
	if not traits.has(attribute):
		print("Trait ", attribute, " does not exist.")
		return

	match upgrade.effect_type:
		"multiply":
			traits[attribute] *= value
		"add":
			traits[attribute] += value
		"subtract":
			traits[attribute] -= value
		"bool": 
			if value == 1:
				traits[attribute] = true
			else:
				traits[attribute] = false
		"divide":
			if value != 0:
				traits[attribute] /= value
			else:
				print("Error: Division by zero.")

func add_upgrade(upgrade: AbilityUpgrade):
	upgrades.append(upgrade)
	apply_upgrades()

func remove_upgrade(upgrade: AbilityUpgrade):
	var name = upgrade.attribute_name
	upgrades.erase(upgrade)
		# Restore the trait to its default value
	if player_traits_default.has(name):
		traits[name] = player_traits_default[name]
	for i in upgrades:
		if i.attribute_name == name:
			apply_upgrade(i)

func apply_food(energy: int, health: int):
	traits.health += ( traits.max_health * (health/100) )
	traits.energy += ( traits.max_energy * (energy/100) )

func collect_coin(amnt):
	player_data.coins += amnt * traits.coin_multiplyer

func shield_damage() -> bool:
	if Global.game_data.shield>0:
		Global.game_data.shield-=1
		return true
	return false

func take_damage():
	var shield_taken: bool = shield_damage()
	if not shield_taken:
		Global.game_data.lives -=1

func purchase_item(item: String):
	Global.player_data.shop[item]["purchased"] = true
	Global.player_data.coins -= Global.player_data.shop[item]["cost"]


func start_game():
	player_traits_default = traits

