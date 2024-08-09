extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "082932H33"


@onready var coins: int = 0
@onready var gems: int = 0

# Array = price, purchased
var cosmetics = {
	"hat": [350,false]
}
