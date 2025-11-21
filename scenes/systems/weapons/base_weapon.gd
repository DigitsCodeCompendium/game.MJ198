extends Resource
class_name  BaseWeapon

@export var bullet_scene = preload("res://scenes/systems/weapons/basic_bullet.tscn")
@export var base_fire_rate = 1
@export var base_damage = 1
@export var base_projectile_velocity = 1000
@export var base_projectile_size = 1
@export var base_projectile_count = 1
@export var base_projectile_spread = 0
@export var base_inacuracy = 0
const MAX_COOLDOWN = 100

var _cooldown: float = 0

func fire_weapon(parent) -> bool:
	if _cooldown == 0:
		_fire(parent)
		_cooldown = MAX_COOLDOWN
		return true
	return false

func _fire(parent) -> void:
	var bullet = bullet_scene.instantiate()
	parent.get_tree().current_scene.add_child(bullet)
	bullet.launch(Vector2(0, -500), parent.owner.position, 1)
	
func cooldown_weapon(amount) -> void:
	_cooldown -= amount
	_cooldown = clamp(_cooldown, 0 , MAX_COOLDOWN)
