extends Shootable
class_name RocketWeapon

@export var bullet_scene = preload("res://scenes/systems/weapons/rocket_launcher/basic_rocket.tscn")
@export var base_fire_rate: float = 0.25
@export var base_damage: float = 20
@export var base_projectile_velocity: float = 500
@export var base_projectile_size: float = 1
const MAX_COOLDOWN: float = 1

@export var weapon_icon: Texture2D

func get_icon():
	return weapon_icon

func init_weapon_state() -> ShootableState:
	return RocketState.new()

func fire_weapon(dir: Vector2, weapon_system: WeaponSystem, weapon_state:ShootableState) -> bool:
	if weapon_state.cooldown == 0:
		_fire(dir, weapon_system, weapon_state)
		var firerate = base_fire_rate
		if weapon_system.module_system != null:
			firerate *= (1 + weapon_system.module_system.get_module_property("weapon_firerate"))
		weapon_state.cooldown = MAX_COOLDOWN / firerate
		return true
	return false

func _fire(dir:Vector2, weapon_system: WeaponSystem, weapon_state:RocketState) -> void:
	var bullet = bullet_scene.instantiate()
	weapon_system.get_tree().current_scene.add_child(bullet)

	var group
	if weapon_system.belongs_to_player:
		group = "player_projectile"
	else:
		group = "enemy_projectile"
	
	var module_system = weapon_system.module_system
	var velocity_mod = 1
	var damage_mod = 1
	var size_mod = 1
	if module_system != null:
		velocity_mod += module_system.get_module_property("weapon_velocity")
		damage_mod += module_system.get_module_property("weapon_damage")
		size_mod += module_system.get_module_property("weapon_size")
	
	var launch_offset = -10
	if weapon_state.last_fired_left:
		launch_offset *= -1
	
	bullet.launch(	self.base_projectile_velocity * dir.normalized() * velocity_mod,
					weapon_system.owner.position + Vector2(launch_offset,0),
					self.base_projectile_size * size_mod,
					self.base_damage * damage_mod,
					group)
	
func cooldown_weapon(delta:float, weapon_state:ShootableState) -> void:
	weapon_state.cooldown -= delta
	weapon_state.cooldown = clamp(weapon_state.cooldown, 0 , MAX_COOLDOWN)
