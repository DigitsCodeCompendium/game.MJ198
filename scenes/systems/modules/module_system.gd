extends Node2D
class_name ModuleSystem

@export var num_module_slots = 5
var module_slots: Array
@export
var power_system: Node

func _ready() -> void:
	for i in range(self.num_module_slots):
		module_slots.append(null)

func add_module(module: BaseModule) -> bool:
	for idx in range(num_module_slots):
		if module_slots[idx] == null:
			module_slots[idx] = module
			print("added module")
			print(module_slots)
			return true
	return false

func set_module(module: BaseModule, slot:int) -> bool:
	if slot < num_module_slots:
		module_slots[slot] = module
		return true
	return false

func get_module(slot:int) -> BaseModule:
	if slot < len(module_slots):
		return module_slots[slot]
	return null

func get_module_property(property: String) -> float:
	var prop_value = 0
	for module_slot in module_slots:
		if module_slot != null:
			prop_value += module_slot.get_module_property(property)
	return prop_value

func slot_has_module(slot: int) -> bool:
	assert(slot < num_module_slots)
	return module_slots[slot] != null

# try to increase the power of a module, will return true on success
# meant for the ui interaction
func increase_module_power(slot: int) -> bool:
	assert(slot < num_module_slots)
	if slot_has_module(slot):
		var module = module_slots[slot]
		var required_power = module.required_increase_power()
		if power_system.request_power(module, required_power):
			module.increase_power()
			return true
	return false

func decrease_module_power(slot: int) -> bool:
	assert(slot < num_module_slots)
	if slot_has_module(slot):
		var module = module_slots[slot]
		var returned_power = module.reduce_power()
		power_system.request_power(module, returned_power)
		return true
	return false
