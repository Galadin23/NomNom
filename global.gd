extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "089SADFH"
var screen_height = 1920
var player_data = PlayerData.new()

func _ready():
	verify_save_directory(SAVE_DIR)
	load_data(SAVE_DIR)

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
		player_data.health = data.player_data.health
		player_data.gems = data.player_data.gems
		
	else:
		printerr("Cannot open non-existent file at %s!" % [path])


