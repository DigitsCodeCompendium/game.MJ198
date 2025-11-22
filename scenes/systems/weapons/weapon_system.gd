extends Node
class_name WeaponSystem

@export var belongs_to_player = false
@export var current_weapon: Shootable
@export var module_system: ModuleSystem

var weapon_state: ShootableState

var has_weapon: bool:
	get:
		return current_weapon != null

var modules_exist: bool: 
	get:
		return module_system != null

func _ready() -> void:
	if has_weapon:
		set_weapon(current_weapon)

func _process(delta: float) -> void:
	if has_weapon:
		current_weapon.cooldown_weapon(delta, weapon_state)
	
	if belongs_to_player:
		if Input.is_action_pressed("shoot"):
			self.fire(Vector2.UP)

func fire(dir:Vector2) -> bool:
	if has_weapon:
		current_weapon.fire_weapon(dir, self, weapon_state)
		return true
	return false

func remove_weapon() -> void:
	current_weapon = null
	weapon_state = null

func set_weapon(weapon:Shootable) -> void:
	current_weapon = weapon
	weapon_state = weapon.init_weapon_state()
