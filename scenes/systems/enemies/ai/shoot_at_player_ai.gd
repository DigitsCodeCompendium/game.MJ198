extends Node

@export var weapon_system: WeaponSystem
@onready var player = get_node("/root/Game/Player")

func _process(_delta):
	var dir: Vector2 = player.position - weapon_system.owner.position
	weapon_system.fire(dir.normalized())
