extends Shootable
class_name CannonWeapon

@export var bullet_scene = preload("res://scenes/systems/weapons/cannon/basic_bullet.tscn")
@export var base_fire_rate = 1
@export var base_damage = 1
@export var base_projectile_velocity = 1000
@export var base_projectile_size = 1
const MAX_COOLDOWN = 1

func init_weapon_state() -> ShootableState:
	return CannonState.new()

func fire_weapon(dir: Vector2, weapon_system: WeaponSystem, weapon_state:ShootableState) -> bool:
	if weapon_state.cooldown == 0:
		_fire(dir, weapon_system)
		var firerate = base_fire_rate
		if weapon_system.module_system != null:
			firerate *= (1 + weapon_system.module_system.get_module_property("weapon_firerate"))
		weapon_state.cooldown = MAX_COOLDOWN / firerate
		return true
	return false

func _fire(dir:Vector2, weapon_system: WeaponSystem) -> void:
	var bullet = bullet_scene.instantiate()
	weapon_system.get_tree().current_scene.add_child(bullet)
	
	var group
	if weapon_system.belongs_to_player:
		group = "player_projectile"
	else:
		group = "enemy_projectile"
	
	bullet.launch(self.base_projectile_velocity * dir.normalized(), weapon_system.owner.position, self.base_projectile_size, self.base_damage, group)
	
func cooldown_weapon(delta:float, weapon_state:ShootableState) -> void:
	weapon_state.cooldown -= delta
	weapon_state.cooldown = clamp(weapon_state.cooldown, 0 , MAX_COOLDOWN)
