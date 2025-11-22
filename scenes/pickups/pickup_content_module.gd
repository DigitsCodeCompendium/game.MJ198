extends Resource
class_name PickupContentModule

@export var module: BaseModule

func get_icon():
	return module.module_icon

func apply_to_player(player: Node):
	player.get_node("Systems/ModuleInsertionSystem").insert_module(module)
