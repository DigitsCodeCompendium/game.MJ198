extends VBoxContainer

@onready var modules = get_children()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEventBus.connect("module_updated",_on_module_updated)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_module_updated(slot:int,mod:BaseModule) -> void:
	modules[slot].update_module(mod)
