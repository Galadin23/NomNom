extends Resource
class_name AbilityUpgrade

# Declare properties for the upgrade
@export var attribute_name: String
@export var effect_type: String  # e.g., "multiply", "add", "subtract", "divide"
@export var effect_value: float