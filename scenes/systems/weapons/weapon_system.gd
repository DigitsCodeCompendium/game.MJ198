extends Node2D
class_name WeaponSystem

@export var belongs_to_player = false
@export var weapon: Shootable = preload("res://resources/weapons/basic_gun.tres")
var has_weapon: bool:
	get:
		return weapon != null

var module_system: Node
var modules_exist: bool: 
	get:
		return module_system != null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	module_system = get_node("../ModuleSystem")
	
func _process(delta: float) -> void:
	if has_weapon:
		weapon.cooldown_weapon(1 * delta)
		
	if Input.is_action_pressed("shoot"):
		self.fire()

func fire() -> bool:
	if has_weapon:
		weapon.fire_weapon(self, module_system)
		return true
	return false
