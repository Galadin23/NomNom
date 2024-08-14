extends Node

const SAVE_DIR: String = "user://saves/"
const SAVE_FILE_NAME: String = "save.json"
const SECURITY_KEY: String = "089SADFH"
var screen_height: int = 1920
var player_data: PlayerData = PlayerData.new()
var traits: Dictionary = player_data.traits
var upgrades: Array = []
var player_traits_default: Dictionary = {}

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
	if player_data == null:
		player_data = PlayerData.new()
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
		player_data.traits = data.player_data.traits
	else:
		printerr("Cannot open non-existent file at %s!" % [path])

func apply_upgrades():
	# Restore default traits
	traits = player_traits_default.duplicate()
	
	for upgrade in upgrades:
		apply_upgrade(upgrade)

func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var attribute: String = upgrade.attribute_name
	var value: float      = upgrade.effect_value
	
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
			traits[attribute] = value
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

func start_game():
	player_traits_default = traits
