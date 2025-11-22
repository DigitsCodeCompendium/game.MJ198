extends Node
class_name EnemyHealth

@export var health_bar: ProgressBar

@export var max_health: float = 10
var health

signal health_depleted()

func _ready():
	health = max_health
	_update_health_bar()

func _update_health_bar():
	if health_bar != null:
		health_bar.value = health / max_health

func reset_health():
	health = max_health
	_update_health_bar()

func damage(amount: float):
	health -= amount
	_update_health_bar()
	if health <= 0:
		health_depleted.emit()
