extends Node
class_name ModuleSystem

@export var num_module_slots = 5
var module_slots: Array
@export
var power_system: Node

func _ready() -> void:
	for i in range(self.num_module_slots):
		module_slots.append(null)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("power_up_module_1"):
		increase_module_power(0)
	elif Input.is_action_just_pressed("power_down_module_1"):
		decrease_module_power(0)
	elif Input.is_action_just_pressed("power_up_module_2"):
		increase_module_power(1)
	elif Input.is_action_just_pressed("power_down_module_2"):
		decrease_module_power(1)
	elif Input.is_action_just_pressed("power_up_module_3"):
		increase_module_power(2)
	elif Input.is_action_just_pressed("power_down_module_3"):
		decrease_module_power(2)
	elif Input.is_action_just_pressed("power_up_module_4"):
		increase_module_power(3)
	elif Input.is_action_just_pressed("power_down_module_4"):
		decrease_module_power(3)
	elif Input.is_action_just_pressed("power_up_module_5"):
		increase_module_power(4)
	elif Input.is_action_just_pressed("power_down_module_5"):
		decrease_module_power(4)

func set_module(slot:int, module: BaseModule) -> bool:
	if slot < num_module_slots:
		module_slots[slot] = module.duplicate()
		
		var power_consumers = []
		for module_slot in module_slots:
			if module_slot != null:
				power_consumers.append(module_slot)
		power_system.power_consumers = power_consumers
		UiEventBus.emit_signal("module_updated", slot, module)
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
			UiEventBus.emit_signal("module_updated", slot, module)
			return true
	return false

func decrease_module_power(slot: int) -> bool:
	assert(slot < num_module_slots)
	if slot_has_module(slot):
		var module = module_slots[slot]
		var returned_power = module.reduce_power(1)
		power_system.request_power(module, -1 * returned_power)
		UiEventBus.emit_signal("module_updated", slot, module)
		return true
	return false
