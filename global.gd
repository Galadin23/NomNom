extends Node

const SAVE_DIR: String = "user://saves/"
const SAVE_FILE_NAME: String = "save.json"
const SECURITY_KEY: String = "089SADFH"
var screen_height: int = 1920
var player_data: PlayerData = PlayerData.new()
var traits: Dictionary = player_data.traits

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

func save_data(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE,SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"player_data": {
			"coins": player_data.coins,
			"gems": player_data.gems,
			"shop": player_data.shop,
		}
	}
	
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
	
func load_data(path:String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("cannot parse %s as a json_string: (%s)" % [path, content])
			return
		player_data = PlayerData.new()
		player_data.coins = data.player_data.health
		player_data.gems = data.player_data.gems
		player_data.shop = data.player_data.shop
	else:
		printerr("Cannot open non-existent file at %s!" % [path])



func apply_food(energy: int, health: int):
	traits.health += ( traits.max_health * (health/100) )
	traits.energy += ( traits.max_energy * (energy/100) )