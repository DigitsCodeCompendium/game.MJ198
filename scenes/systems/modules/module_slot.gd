extends Object
class_name ModuleSlot

var _module: BaseModule
var module: BaseModule:
	get:
		return _module

var is_active: bool = false
var _extra_power: int = 0
var _current_level: int = 0 #level is 0,1,2,3
var _level_progress: int = 0 #module levels up when progress = level + 1 (so requires 1 dup to level 0->1, 2 dups to level 1->2, and so on)

var current_power: int:
	get:
		if is_active:
			return module.activation_power + _extra_power
		return 0
var activation_power: int:
	get:
		return module.activation_power
var extra_power_limit: int:
	get:
		return module.base_extra_power_limit + module.level_extra_power_limit_scaling[_current_level]
var max_power: int:
	get:
		return activation_power + extra_power_limit
var current_level: int:
	get:
		return _current_level
var level_progress: int:
	get:
		return _level_progress


#interface functions for power system
func is_passive_consumer():
	return true if _module == null else _module.is_passive_consumer()


func set_module(new_module: BaseModule):
	_module = new_module
	is_active = false
	_extra_power = 0
	_current_level = 0
	_level_progress = 0

# interface for power system, power system requests we reduce the power level
# but if the module gets deactivated we return the full activation cost
func reduce_power(amount: int) -> int:
	if is_active:
		if amount <= _extra_power:
			_extra_power -= amount
			return amount
		else:
			print("module deactivated")
			is_active = false
			_extra_power = 0
			return activation_power + _extra_power
	return 0


# return value of the requested property
func get_module_property(property: String) -> float:
	if _module == null:
		return 0
	
	var value = 0
	value += _module.passive_properties.get(property, 0)
	if is_active:
		value += _module.active_properties.get(property, 0)
		value += _module.scaling_properties.get(property, 0) * _extra_power
	return value * _module.level_property_scaling[_current_level]


func add_level_progress(progress: int):
	assert(_module != null)
	
	_level_progress += progress
	while _current_level < 3 and _level_progress > _current_level + 1:
		_current_level += 1
		_level_progress -= _current_level


# tries to increase the extra power of the 
func required_increase_power() -> int:
	if not is_active:
		return _module.activation_power
	elif _extra_power < extra_power_limit:
		return 1
	return 0


func increase_power() -> void:
	if not is_active:
		print("module activated")
		is_active = true
	elif _extra_power < extra_power_limit:
		_extra_power += 1
