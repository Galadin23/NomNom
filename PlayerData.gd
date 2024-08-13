extends Resource
class_name PlayerData
# ALL DATA NUMBERS HERE ARE DEFAULT WHEN USER HAS A NEW GAME


@export var coins: int = 200
@export var gems: int = 5
@export var equipped_hat: String = "none"
@export var shop: Dictionary = {
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
}

@export var traits: Dictionary = {
	"speed": 10, # how fast he can switch lanes
	"max_speed": 20,

	"dive": 2, # how long you can stay underwater (seconds)
	"max_dive": 5,

	"energy_depletion": 0, # how fast your energy depletes (N p/s)
	"energy": 100, # How much energy you have
	"max_energy": 100,

	"max_upgrade_energy": 300,

	"health": 100, # whats the max healthiness you can have
	"max_health": 100,
	"max_upgrade_health": 300,

	"shield": 20, # How long the shield lasts (seconds)
	"max_shield": 60,
	"shield_effectivenes": 1, # How many blows the shield takes
	"max_shield_effectiveness":3,

	"magnet": 10, # How long the magnet lasts (seconds)
	"max_magnet": 60,

	"invincible": 10, # How long he's invincible (seconds)
	"max_invincible": 30,

	"sleep_boost_multiplyer": 1,
	"coin_multiplyer":1,
	"treasure_return": false,

}

@export var statistics: Dictionary = {
	"meters_run": 0,
	"total_coins":0,
	"longest_distance":0,
	"longest time": 0,
}