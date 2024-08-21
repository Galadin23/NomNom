extends Node2D
@export var upgrade_name = "" # what the name of the upgrade is
@export var attribute = ""
@export var value: float = 1
@export var time_wait: float = 1
@export var effect_type = ""
@export var status: String = ""

var possible_status: Array = ["permanent","timer","expired"]
@onready var timer:Timer = $Timer
@onready var power_upgrade = AbilityUpgrade.new()
@onready var anim = $AnimationPlayer
func powerup_preset(powerup_name):
	
	if powerup_name ==	"magnet" or powerup_name ==	"m":
			upgrade("magnet_enabled",1,"bool")
			status = "timer"
			timer.wait_time = Global.player_data.traits.magnet
			timer.start()
			return true
	if powerup_name ==	"shield" or powerup_name ==	"s":
			status = "timer"
			timer.wait_time = Global.traits.shield
			timer.start()
			upgrade("shield_enabled",1,"bool")
			Global.game_data.shield = Global.traits.shield_effectivenes
			return true
		
			
func upgrade(attribute: String, value: float, effect_type: String):
	power_upgrade.attribute_name = attribute
	power_upgrade.effect_value = value
	power_upgrade.effect_type = effect_type
	if status == "timer":
		timer.wait_time = Global.player_data.traits.magnet
		timer.start()
	Global.add_upgrade(power_upgrade)

func set_status(new_status) -> void:
	if not new_status  in possible_status:
		print("Error: not possible status. Defaulting to timed")
		return
	status = new_status

func get_status():
	return status

func set_up():
	if upgrade_name ==	"magnet" or upgrade_name ==	"m":
		anim.play("magnet")

func _on_timer_timeout():
	if status == "timer":
		status = "expired"
		Global.remove_upgrade(power_upgrade)

func _on_area_2d_body_entered(body):
	var success = powerup_preset(upgrade_name)
	if not success: 
		upgrade(attribute,value,effect_type)
