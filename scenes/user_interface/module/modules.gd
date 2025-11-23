extends VBoxContainer

@onready var modules = get_children()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEventBus.connect("module_updated",_on_module_updated)
	for i in len(modules):
		modules[i].set_slot(i)

func _on_module_updated(slot:int, mod:ModuleSlot) -> void:
	modules[slot].update_module(mod)
