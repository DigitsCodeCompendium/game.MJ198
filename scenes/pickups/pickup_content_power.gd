extends Resource
class_name PickupContentPower
@export var amount: int = 1

func apply_to_player(player: Node):
	var power_system: PowerSystem = player.get_node("Systems/PowerSystem")
	assert(power_system != null)
	power_system.current_max_power += amount
