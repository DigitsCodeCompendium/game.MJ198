extends Node
class_name EnemyHealth

@export var health_bar: ProgressBar

@export var max_health: float = 10
var health: float
var alive: bool

signal health_depleted()

func _ready():
	health = max_health
	alive = true
	_update_health_bar()

func _update_health_bar():
	if health_bar != null:
		health_bar.value = health / max_health

func reset_health():
	health = max_health
	alive = true
	_update_health_bar()

func damage(amount: float):
	health -= amount
	_update_health_bar()
	if alive and health <= 0:
		alive = false
		health_depleted.emit()
