extends CannonWeapon
class_name SweepCannonWeapon

@export var number_of_projectiles: int = 8
@export var spread: float = 40
@export var sweep_speed: float = 15

func get_icon():
	return weapon_icon

func init_weapon_state() -> ShootableState:
	var state = SweepCannonState.new()
	state.max_fire_port = len(firing_ports)
	return state

func fire_weapon(dir: Vector2, weapon_system: WeaponSystem) -> bool:
	if weapon_system.weapon_state.cooldown == 0:
		weapon_system.weapon_state.burst_active = true
		weapon_system.weapon_state.burst_cooldown = sweep_speed
		var firerate = base_fire_rate
		if weapon_system.module_system != null:
			firerate *= (1 + weapon_system.module_system.get_module_property("weapon_firerate"))
		weapon_system.weapon_state.cooldown = MAX_COOLDOWN / firerate
		return true
	
	if weapon_system.weapon_state.burst_active:
		if weapon_system.weapon_state.burst_cooldown == 0:
			_fire(dir, weapon_system)
			weapon_system.weapon_state.burst_cooldown = sweep_speed
			weapon_system.weapon_state.burst_idx += 1
			
			if weapon_system.weapon_state.burst_idx >= number_of_projectiles:
				weapon_system.weapon_state.burst_active =false
				weapon_system.weapon_state.burst_idx = 0
				
			return true
	return false

func _fire(dir:Vector2, weapon_system: WeaponSystem) -> void:
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

	var weapon_state: SweepCannonState = weapon_system.weapon_state
	var offset = Vector2.ZERO
	if weapon_state.max_fire_port > 0:
		offset = firing_ports[0]
	
	var random_accuracy = (spread * (float(weapon_state.burst_idx)/float(number_of_projectiles-1)))- (spread/2)
	print("---ree---")
	print(float(weapon_state.burst_idx)/float(number_of_projectiles))
	print(weapon_state.burst_idx)
	print(random_accuracy)
	
	var direction = dir.rotated(random_accuracy * PI/180)
	var bullet = bullet_scene.instantiate()
	weapon_system.get_tree().current_scene.add_child(bullet)

	bullet.launch(	self.base_projectile_velocity * direction * velocity_mod,
					weapon_system.owner.position + offset,
					self.base_projectile_size * size_mod,
					self.base_damage * damage_mod,
					group,
					weapon_system)
	
func cooldown_weapon(delta:float, weapon_system:WeaponSystem) -> void:
	var weapon_state = weapon_system.weapon_state
	weapon_state.cooldown -= delta
	weapon_state.cooldown = clamp(weapon_state.cooldown, 0 , 9999999)
	weapon_state.burst_cooldown -= delta
	weapon_state.burst_cooldown = clamp(weapon_state.burst_cooldown, 0 , 9999999)
