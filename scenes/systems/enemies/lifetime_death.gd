extends Node

@export var lifetime = 10

signal on_death()

func _ready():
	var death_timer = get_tree().create_timer(lifetime)
	await death_timer.timeout
	on_death.emit()
	owner.queue_free()
