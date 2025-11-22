extends PickupContent
class_name PickupContentWeapon

@export var weapon: Shootable

func get_icon():
	return weapon.get_icon()

func apply_to_player(player):
	player.get_node("Systems/WeaponInsertionSystem").insert_weapon(weapon)
