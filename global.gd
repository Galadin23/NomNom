extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "089SADFH"
var screen_height = 1920
var player_data = PlayerData.new()

var default_data = {
	"player_data": {
		"coins": 200,
		"gems": 5,
		"shop": {
			"cos_1": {
				"name": "Cow Beanie",
				"image": "cow_hat",
				"cost": 300,
				"purchased": false,
				"description": "Moo-ve over ordinary hats, this beanie brings all the charm of a farmyard friend!"
			},
			"cos_2": {
				"name": "Pig Beanie",
				"image": "pig_hat",
				"cost": 600,
				"purchased": false,
				"description": "Snout-tastic and snug! This pig beanie is sure to make you the cutest critter around."
			},
			"cos_3": {
				"name": "Unicorn Headband",
				"image": "unicorn_headband",
				"cost": 800,
				"purchased": false,
				"description": "Sparkle and shine with this magical unicorn headband. Perfect for turning any day into a fairy tale!"
			},
			"cos_4": {
				"name": "Rainbow Scarf",
				"image": "rainbow_scarf",
				"cost": 500,
				"purchased": false,
				"description": "Brighten up your outfit with this vibrant rainbow scarf. It’s like wearing a rainbow hug!"
			},
			"cos_5": {
				"name": "Cat Ears Headband",
				"image": "cat_ears_headband",
				"cost": 400,
				"purchased": false,
				"description": "Purrfect for feline fans! These cat ears are an adorable way to add a touch of whimsy to your look."
			},
			"cos_6": {
				"name": "Starry Night Hat",
				"image": "starry_night_hat",
				"cost": 700,
				"purchased": false,
				"description": "Gaze at the stars and dream big with this enchanting hat covered in a galaxy of glittering stars."
			},
			"cos_7": {
				"name": "Bunny Ears Headband",
				"image": "bunny_ears_headband",
				"cost": 350,
				"purchased": false,
				"description": "Hop into cuteness with this adorable bunny ears headband. It's a fluffy way to add some fun to your outfit!"
			},
			"cos_8": {
				"name": "Dragon Scale Cape",
				"image": "dragon_scale_cape",
				"cost": 900,
				"purchased": false,
				"description": "Unleash your inner dragon with this stunning cape. Each scale sparkles with a hint of magic!"
			},
			"cos_9": {
				"name": "Cherry Blossom Kimono",
				"image": "cherry_blossom_kimono",
				"cost": 650,
				"purchased": false,
				"description": "Wrap yourself in the elegance of spring with this cherry blossom kimono. It’s like wearing a garden of flowers!"
			},
			"cos_10": {
				"name": "Robot Helmet",
				"image": "robot_helmet",
				"cost": 550,
				"purchased": false,
				"description": "Gear up for a futuristic adventure with this sleek robot helmet. Perfect for tech enthusiasts and adventurers alike!"
			}
		},
		"statistics": {
			"meters_run": 0,
			"total_coins":0,
			"longest_distance":0,
			"longest time": 0,
		},
		"traits": {
			"speed": 0, # how fast he can switch lanes
			"jump": 0, # how long you jump?
			"dive": 0, # how long you can stay underwater
			"energy": 0, # how fast your energy depletes
			"energy_amnt": 100, # How much energy you have
			"health": 100, # whats the max healthiness you can have
			"shield":0, # How long the shield lasts
			"shield_effectivenes":0, # How many blows the shield takes
			"magnet":0, # How long the magnet lasts
			"invincible":0, # How long he's invincible
		},
	}
}

func _ready():
	verify_save_directory(SAVE_DIR)
	load_data(SAVE_DIR)
	if player_data == null:
		player_data = PlayerData.new()
		player_data.coins = default_data.player_data.coins
		player_data.gems = default_data.player_data.gems
		player_data.shop = default_data.player_data.shop
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



