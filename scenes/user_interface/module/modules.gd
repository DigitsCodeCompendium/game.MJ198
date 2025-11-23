extends VBoxContainer

@onready var modules = get_children()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEventBus.connect("module_updated", _on_module_updated)
	UiEventBus.connect("module_discard_progress", _on_module_discard_progress)
	
	for i in len(modules):
		modules[i].set_slot(i)

func _on_module_updated(slot:int, mod:ModuleSlot) -> void:
	modules[slot].update_module(mod)

func _on_module_discard_progress(slot: int, progress: float):
	modules[slot].update_discard_progress(progress)
