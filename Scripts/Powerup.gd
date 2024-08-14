extends Node2D
@export var upgrade_name = "" # what the name of the upgrade is
@export var attribute = ""
@export var value = 1
@export var effect_type = ""
@export var status: String = ""
var possible_status: Array = ["permanent","timer","expired"]
@onready var timer:Timer = $Timer
@onready var power_upgrade = AbilityUpgrade.new()

func powerup_preset(powerup_name):
	match powerup_name:
		"magnet":
			upgrade("magnet_enabled",true,"bool")
			status = "timer"
			timer.wait_time = Global.player_data.traits.magnet
			

func _ready():
	upgrade(attribute,value,effect_type)
	powerup_preset(upgrade_name)

func upgrade(attribute: String, value: float, effect_type: String):
	power_upgrade.attribute_name = attribute
	power_upgrade.effect_value = value
	power_upgrade.effect_type = effect_type
	Global.add_upgrade(power_upgrade)

func set_status(new_status) -> void:
	if not new_status  in possible_status:
		print("Error: not possible status. Defaulting to timed")
		return
	status = new_status

func get_status():
	return status

func _on_timer_timeout():
	if status == "timer":
		status = "expired"
		Global.remove_upgrade(power_upgrade)
