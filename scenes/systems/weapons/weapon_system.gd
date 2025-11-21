extends Node2D

@export var belongs_to_player = false
@export var weapon: BaseWeapon = preload("res://resources/base_weapon.tres")
var has_weapon: bool:
	get:
		return weapon != null

var upgrade_system: Node
var upgrades_exist: bool:
	get:
		return upgrade_system != null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_system = get_node("../UpgradeSystem")
	
func _process(delta: float) -> void:
	if has_weapon:
		weapon.cooldown_weapon(200 * delta)
		
	if Input.is_action_pressed("shoot"):
		self.fire()

func fire() -> bool:
	if has_weapon:
		weapon.fire_weapon(self)
		return true
	return false

#func _fire(dir:Vector2) -> void:
	
