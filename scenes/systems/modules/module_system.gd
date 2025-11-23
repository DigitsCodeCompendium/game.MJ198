extends Node
class_name ModuleSystem

@export var num_module_slots = 5
var module_slots: Array[ModuleSlot]
@export
var power_system: PowerSystem

func _ready() -> void:
	for i in range(self.num_module_slots):
		module_slots.append(ModuleSlot.new())

func _process(_delta: float) -> void:
	for i in range(5):
		if Input.is_action_just_pressed("power_up_module_%d" % (i+1)):
			increase_module_power(i)
		elif Input.is_action_just_pressed("power_down_module_%d" % (i+1)):
			decrease_module_power(i)

func set_module(slot:int, module: BaseModule) -> bool:
	if slot < num_module_slots:
		module_slots[slot].set_module(module)
		
		power_system.power_consumers = module_slots
		UiEventBus.emit_signal("module_updated", slot, module_slots[slot])
		return true
	return false

func get_module(slot:int) -> BaseModule:
	if slot < len(module_slots):
		return module_slots[slot].module
	return null

func get_module_property(property: String) -> float:
	var prop_value = 0
	for module_slot in module_slots:
		prop_value += module_slot.get_module_property(property)
	return prop_value

func slot_has_module(slot: int) -> bool:
	assert(slot < num_module_slots)
	return module_slots[slot].module != null

# try to increase the power of a module, will return true on success
# meant for the ui interaction
func increase_module_power(slot: int) -> bool:
	assert(slot < num_module_slots)
	if slot_has_module(slot):
		var module = module_slots[slot]
		var required_power = module.required_increase_power()
		if required_power != 0:
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
