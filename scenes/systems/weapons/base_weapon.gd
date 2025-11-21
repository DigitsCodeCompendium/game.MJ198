extends Shootable
class_name BaseWeapon

@export var bullet_scene = preload("res://scenes/systems/weapons/basic_bullet.tscn")
@export var base_fire_rate = 1
@export var base_damage = 1
@export var base_projectile_velocity = 1000
@export var base_projectile_size = 1
var max_cooldown = 1

var _cooldown: float = 0

func fire_weapon(weapon_system: WeaponSystem, module_system: ModuleSystem) -> bool:
	if _cooldown == 0:
		_fire(weapon_system, module_system)
		var firerate = base_fire_rate * (1 + module_system.get_module_property("weapon_firerate"))
		_cooldown = max_cooldown / firerate
		return true
	return false

func _fire(weapon_system: WeaponSystem, _module_system: ModuleSystem) -> void:
	var bullet = bullet_scene.instantiate()
	weapon_system.get_tree().current_scene.add_child(bullet)
	bullet.launch(Vector2(0, -1 * self.base_projectile_velocity), weapon_system.owner.position, self.base_projectile_size, self.base_damage)
	
func cooldown_weapon(amount) -> void:
	_cooldown -= amount
	_cooldown = clamp(_cooldown, 0 , max_cooldown)
