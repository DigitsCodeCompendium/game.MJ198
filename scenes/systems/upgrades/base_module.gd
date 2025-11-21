extends Resource
class_name BaseModule

@export var base_activation_power: int
@export var base_max_extra_power: int
@export var base_passive_properties: Dictionary[String, float] = {} #properties that are provided all the time
@export var base_active_properties: Dictionary[String, float] = {} #properties that are provided when activated
@export var base_scaling_properties: Dictionary[String, float] = {} #properties that provide aditional scaling amounts based on extra power given

#interface functions for power system
func is_passive_consumer():
	return true
	
var is_active: bool = false
var _extra_power: int = 0
var current_power: int:
	get:
		if is_active:
			return base_activation_power + _extra_power
		return 0

# interface for power system, power system requests we reduce the power level
# but if the module gets deactivated we return the full activation cost
func reduce_power(amount: int) -> int:
	if is_active:
		if amount >= _extra_power:
			_extra_power -= amount
			return amount
		else:
			is_active = false
			return base_activation_power
	return 0

# return value of the requested property
func get_module_property(property: String) -> float:
	var value = 0
	value += self.base_passive_properties.get(property, 0)
	if is_active:
		value += self.base_properties.get(property, 0)
		value += self.base_scaling_properties.get(property, 0) * _extra_power
	return value

# tries to increase the extra power of the 
func required_increase_power() -> int:
	if not is_active:
		return base_activation_power
	elif _extra_power < base_max_extra_power:
		return 1
	return 0
	
func increase_power() -> void:
	if not is_active:
		is_active = true
	elif _extra_power < base_max_extra_power:
		_extra_power += 1
