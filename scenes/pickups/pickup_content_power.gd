extends PickupContent
class_name PickupContentPower

@export var amount: int = 1
@export var icon: Texture2D
@export var vis_scene: PackedScene

func get_icon():
	return icon

func get_visu_scene():
	return vis_scene

func apply_to_player(player: Node):
	var power_system: PowerSystem = player.get_node("Systems/PowerSystem")
	assert(power_system != null)
	power_system.current_max_power += amount
