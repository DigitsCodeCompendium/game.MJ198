extends CannonWeapon
class_name ShotgunWeapon

@export var base_number_of_projectiles: int = 6
@export var base_spread: float = 40

func get_icon():
	return weapon_icon

func init_weapon_state() -> ShootableState:
	var state = ShotgunState.new()
	state.max_fire_port = len(firing_ports)
	return state

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
	var proj_num_mod = 1
	var spread_mod = 1
	if module_system != null:
		velocity_mod += module_system.get_module_property("weapon_velocity")
		damage_mod += module_system.get_module_property("weapon_damage")
		size_mod += module_system.get_module_property("weapon_size")
		proj_num_mod += module_system.get_module_property("weapon_projectile_number")
		spread_mod += module_system.get_module_property("weapon_spread")

	var weapon_state: ShotgunState = weapon_system.weapon_state
	var offset = Vector2.ZERO
	if weapon_state.max_fire_port > 0:
		if weapon_state.last_fire_port < weapon_state.max_fire_port:
			offset = firing_ports[weapon_state.last_fire_port]
			weapon_state.last_fire_port += 1
		else:
			offset = firing_ports[0]
			weapon_state.last_fire_port = 1

	for i in range(base_number_of_projectiles * proj_num_mod):
		var mod_spread = spread_mod * base_spread
		var random_accuracy = randf_range(-mod_spread/2, mod_spread/2) * PI/180
		var dir_x = dir.normalized().x
		var dir_y = dir.normalized().y
		var direction = Vector2(dir_x * sin(random_accuracy) - dir_y * sin(random_accuracy),
								dir_x * cos(random_accuracy) + dir_y * cos(random_accuracy))
		var bullet = bullet_scene.instantiate()
		weapon_system.get_tree().current_scene.add_child(bullet)

		bullet.launch(	self.base_projectile_velocity * direction * velocity_mod,
						weapon_system.owner.position + offset,
						self.base_projectile_size * size_mod,
						self.base_damage * damage_mod,
						group)
	
func cooldown_weapon(delta:float, weapon_system:WeaponSystem) -> void:
	var weapon_state = weapon_system.weapon_state
	weapon_state.cooldown -= delta
	weapon_state.cooldown = clamp(weapon_state.cooldown, 0 , MAX_COOLDOWN)
