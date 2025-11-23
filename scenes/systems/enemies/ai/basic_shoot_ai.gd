extends Node

@export
var weapon_system: WeaponSystem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	weapon_system.fire(Vector2.DOWN)
