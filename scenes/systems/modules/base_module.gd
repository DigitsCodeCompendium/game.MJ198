extends Resource
class_name BaseModule

@export var is_passive_module: bool
@export var activation_power: int
@export var base_extra_power_limit: int
@export var level_extra_power_limit_scaling: Array[int] = [0, 0, 0, 0]
@export var passive_properties: Dictionary[String, float] = {} #properties that are provided all the time
@export var active_properties: Dictionary[String, float] = {} #properties that are provided when activated
@export var scaling_properties: Dictionary[String, float] = {} #properties that provide aditional scaling amounts based on extra power given
@export var level_property_scaling: Array[float] = [1, 1.3, 1.6, 2] #property multiplier based on level

@export var module_icon: Texture2D

#interface functions for power system
func is_passive_consumer():
	return true
