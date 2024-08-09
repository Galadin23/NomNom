extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "089SADFH"

var player_data = PlayerData.new()

func _ready():
	verify_save_directory(SAVE_DIR)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save_data(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE,SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return

