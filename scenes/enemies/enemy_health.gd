extends Node
class_name EnemyHealth

@export var max_health: float = 10
var health

signal health_depleted()

func _ready():
	health = max_health

func reset_health():
	health = max_health

func damage(amount: float):
	health -= amount
	print("Health %.2f/%.2f" % [health, max_health])
	if health <= 0:
		health_depleted.emit()
