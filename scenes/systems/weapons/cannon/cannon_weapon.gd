extends Shootable
class_name CannonWeapon

@export var bullet_scene = preload("res://scenes/systems/weapons/cannon/basic_bullet.tscn")
@export var base_fire_rate: float = 1
@export var base_damage: float = 1
@export var base_projectile_velocity: float = 500
@export var base_projectile_size: float = 1
@export var firing_ports: Array[Vector2]
const MAX_COOLDOWN: float = 1

@export var weapon_icon: Texture2D
@export var weapon_sfx: AudioStream

func get_icon():
	return weapon_icon

func init_weapon_state() -> ShootableState:
	var state = CannonState.new()
	state.max_fire_port = len(firing_ports)
	return state

func fire_weapon(dir: Vector2, weapon_system: WeaponSystem) -> bool:
	if weapon_system.weapon_state.cooldown == 0:
		_fire(dir, weapon_system)
		var firerate = base_fire_rate
		if weapon_system.module_system != null:
			firerate *= (1 + weapon_system.module_system.get_module_property("weapon_firerate"))
		weapon_system.weapon_state.cooldown = MAX_COOLDOWN / firerate
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
		
	var module_system = weapon_system.module_system
	var velocity_mod = 1
	var damage_mod = 1
	var size_mod = 1
	if module_system != null:
		velocity_mod += module_system.get_module_property("weapon_velocity")
		damage_mod += module_system.get_module_property("weapon_damage")
		size_mod += module_system.get_module_property("weapon_size")
	
	var weapon_state: CannonState = weapon_system.weapon_state
	var offset = Vector2.ZERO
	if weapon_state.max_fire_port > 0:
		if weapon_state.last_fire_port < weapon_state.max_fire_port:
			offset = firing_ports[weapon_state.last_fire_port]
			weapon_state.last_fire_port += 1
		else:
			offset = firing_ports[0]
			weapon_state.last_fire_port = 1
	
	#rotate the offset in the direction we're trying to fire the gun
	offset = offset.rotated(dir.angle()+ PI/2)
	
	bullet.launch(	self.base_projectile_velocity * dir.normalized() * velocity_mod,
					weapon_system.owner.position + offset,
					self.base_projectile_size * size_mod,
					self.base_damage * damage_mod,
					group,
					weapon_system)
	
func cooldown_weapon(delta:float, weapon_system:WeaponSystem) -> void:
	var weapon_state = weapon_system.weapon_state
	weapon_state.cooldown -= delta
	weapon_state.cooldown = clamp(weapon_state.cooldown, 0 , MAX_COOLDOWN)
